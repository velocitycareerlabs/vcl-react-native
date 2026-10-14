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
    expect(error.cause).toBeUndefined();
  });

  it('keeps a rejection that is not a bridged VCLError as the cause', async () => {
    const nativeRejection = Object.assign(new Error('Native module crashed'), {
      code: 'EUNSPECIFIED',
      nativeStackAndroid: [{ class: 'VclReactNativeModule', lineNumber: 84 }],
    });
    getCredentialManifest.mockRejectedValueOnce(nativeRejection);

    const error = await catchGetCredentialManifestError();

    expect(error).toBeInstanceOf(VCLError);
    expect(error.message).toBe('Native module crashed');
    expect(error.cause).toBe(nativeRejection);
    expect(error.errorCode).toBeUndefined();
  });
});
