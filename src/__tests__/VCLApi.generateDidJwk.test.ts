import { NativeModules } from 'react-native';
import vcl, { VCLError, VCLSignatureAlgorithm } from '../index';

jest.mock('react-native', () => ({
  NativeModules: {
    VclReactNative: { generateDidJwk: jest.fn() },
  },
}));

const BRIDGED_VCL_ERROR_CODE = 'VCL_BRIDGED_ERROR_V1';

const didJwk = {
  did: 'did:jwk:eyJrdHkiOiJFQyIsImNydiI6IlAtMjU2In0',
  publicJwk: { valueStr: '{"kty":"EC","crv":"P-256"}' },
  kid: 'did:jwk:eyJrdHkiOiJFQyIsImNydiI6IlAtMjU2In0#0',
  keyId: 'key-id',
};

describe('VclApi.generateDidJwk', () => {
  const generateDidJwk = NativeModules.VclReactNative
    .generateDidJwk as jest.Mock;

  beforeEach(() => {
    generateDidJwk.mockReset();
  });

  it('leaves a missing signatureAlgorithm for the native bridge to default', async () => {
    generateDidJwk.mockResolvedValueOnce(didJwk);

    await expect(vcl.generateDidJwk({})).resolves.toEqual(didJwk);

    expect(generateDidJwk).toHaveBeenCalledWith({});
  });

  it('passes the signatureAlgorithm through unchanged', async () => {
    generateDidJwk.mockResolvedValueOnce(didJwk);

    await vcl.generateDidJwk({
      signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1,
    });

    expect(generateDidJwk).toHaveBeenCalledWith({
      signatureAlgorithm: 'secp256k1',
    });
  });

  it('surfaces a native rejection of an unsupported signatureAlgorithm as a VCLError', async () => {
    const message =
      'Unsupported signatureAlgorithm "RS256". Expected one of: ES256, P-256, ES256K, secp256k1.';
    generateDidJwk.mockRejectedValueOnce(
      Object.assign(
        new Error(JSON.stringify({ errorCode: 'sdk_error', message })),
        { code: BRIDGED_VCL_ERROR_CODE }
      )
    );

    const error = await vcl
      .generateDidJwk({
        signatureAlgorithm: 'RS256' as VCLSignatureAlgorithm,
      })
      .catch((e: unknown) => e);

    expect(error).toBeInstanceOf(VCLError);
    expect(error).toMatchObject({ errorCode: 'sdk_error', message });
  });
});
