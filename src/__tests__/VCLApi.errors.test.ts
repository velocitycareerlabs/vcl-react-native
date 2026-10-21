import { NativeModules } from 'react-native';
import vcl, {
  VCLError,
  type VCLCredentialManifestDescriptorByDeepLink,
} from '../index';

jest.mock('react-native', () => ({
  NativeModules: {
    VclReactNative: { getCredentialManifest: jest.fn() },
  },
}));

const BRIDGED_VCL_ERROR_CODE = 'VCL_BRIDGED_ERROR_V1';

const requestUri =
  'https://agent.example.com/api/holder/v0.6/org/did:web:issuer.example.com/issue/get-credential-manifest?exchange_id=64dcc64915b0660266ae356a&credential_types=EmailV1.0';

const credentialManifestDescriptor: VCLCredentialManifestDescriptorByDeepLink =
  {
    deepLink: {
      value: `velocity-network://issue?request_uri=${encodeURIComponent(requestUri)}`,
    },
    didJwk: {
      did: 'did:jwk:eyJrdHkiOiJFQyJ9',
      publicJwk: { valueStr: '{"kty":"EC"}' },
      kid: 'did:jwk:eyJrdHkiOiJFQyJ9#0',
      keyId: 'key-id',
    },
  };

const sixFieldPayload = {
  payload:
    '{"error":"Bad Request","errorCode":"exchange_invalid","message":"Exchange is in an invalid state","statusCode":400}',
  error: 'Bad Request',
  errorCode: 'client_request_rejected',
  requestId: 'request-123',
  message: 'Exchange is in an invalid state',
  statusCode: 400,
};

const taxonomyContext = {
  sourceErrorCode: 'exchange_invalid',
  validationPhase: 'client_request_fetch',
  requestDid: 'did:web:issuer.example.com',
  requestUri,
  requestKind: 'issuing_request',
};

describe('VclApi error bridging', () => {
  const getCredentialManifest = NativeModules.VclReactNative
    .getCredentialManifest as jest.Mock;

  const rejectWithBridgedError = (serializedError: object) =>
    getCredentialManifest.mockRejectedValueOnce(
      Object.assign(new Error(JSON.stringify(serializedError)), {
        code: BRIDGED_VCL_ERROR_CODE,
      })
    );

  const catchGetCredentialManifestError = async (): Promise<VCLError> => {
    try {
      await vcl.getCredentialManifest(credentialManifestDescriptor);
    } catch (error) {
      return error as VCLError;
    }

    throw new Error('Expected getCredentialManifest to reject');
  };

  it('exposes the native taxonomy context of a bridged error', async () => {
    rejectWithBridgedError({
      ...sixFieldPayload,
      ...taxonomyContext,
      diagnostics: {
        nativePlatform: 'android',
        nativeType: 'io.velocitycareerlabs.api.entities.error.VCLError',
      },
    });

    const error = await catchGetCredentialManifestError();

    expect(error).toBeInstanceOf(VCLError);
    expect(error).toMatchObject({
      payload: sixFieldPayload.payload,
      error: 'Bad Request',
      errorCode: 'client_request_rejected',
      requestId: 'request-123',
      message: 'Exchange is in an invalid state',
      statusCode: 400,
      sourceErrorCode: 'exchange_invalid',
      validationPhase: 'client_request_fetch',
      requestDid: 'did:web:issuer.example.com',
      requestUri,
      requestKind: 'issuing_request',
      diagnostics: {
        nativePlatform: 'android',
        nativeType: 'io.velocitycareerlabs.api.entities.error.VCLError',
      },
    });
  });

  it.each([
    {
      form: 'an encoded token at the end',
      reportedRequestUri: `${requestUri}&push_delegate.push_url=https%3A%2F%2Fpush.example.com&push_delegate.push_token=fcm%3AAPA91bExampleToken`,
      expectedRequestUri: `${requestUri}&push_delegate.push_url=https%3A%2F%2Fpush.example.com&push_delegate.push_token=[redacted]`,
    },
    {
      form: 'a raw token before other parameters',
      reportedRequestUri:
        'https://agent.example.com/issue/get-credential-manifest?push_delegate.push_token=fcm:APA91bExampleToken&issuerDid=did:web:issuer.example.com',
      expectedRequestUri:
        'https://agent.example.com/issue/get-credential-manifest?push_delegate.push_token=[redacted]&issuerDid=did:web:issuer.example.com',
    },
  ])(
    'redacts the push token in requestUri, given $form',
    async ({ reportedRequestUri, expectedRequestUri }) => {
      rejectWithBridgedError({
        ...sixFieldPayload,
        ...taxonomyContext,
        requestUri: reportedRequestUri,
      });

      const error = await catchGetCredentialManifestError();

      expect(error.requestUri).toBe(expectedRequestUri);
    }
  );

  it('leaves missing or non-string taxonomy context undefined', async () => {
    rejectWithBridgedError({
      ...sixFieldPayload,
      sourceErrorCode: 400,
      validationPhase: null,
      requestDid: { did: 'did:web:issuer.example.com' },
      requestUri: [requestUri],
    });

    const error = await catchGetCredentialManifestError();

    expect(error.errorCode).toBe('client_request_rejected');
    expect(error.sourceErrorCode).toBeUndefined();
    expect(error.validationPhase).toBeUndefined();
    expect(error.requestDid).toBeUndefined();
    expect(error.requestUri).toBeUndefined();
    expect(error.requestKind).toBeUndefined();
  });

  it('still parses a six-field payload from an older native bridge', async () => {
    rejectWithBridgedError(sixFieldPayload);

    const error = await catchGetCredentialManifestError();

    expect(error).toMatchObject({
      payload: sixFieldPayload.payload,
      error: 'Bad Request',
      errorCode: 'client_request_rejected',
      requestId: 'request-123',
      message: 'Exchange is in an invalid state',
      statusCode: 400,
    });
    expect(error.sourceErrorCode).toBeUndefined();
    expect(error.validationPhase).toBeUndefined();
    expect(error.requestDid).toBeUndefined();
    expect(error.requestUri).toBeUndefined();
    expect(error.requestKind).toBeUndefined();
  });
});
