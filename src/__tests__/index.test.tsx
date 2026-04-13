import { VCLError } from '../api/entities/error/VCLError';
import {
  BRIDGED_VCL_ERROR_CODE,
  VCLErrorDeserializer,
} from '../api/entities/error/VCLErrorDeserializer';

describe('VCLError', () => {
  it('keeps the constructor as a plain structured initializer', () => {
    const error = new VCLError({
      payload: '{"details":"payload"}',
      error: 'invalid_request',
      errorCode: 'sdk_error',
      requestId: 'request-123',
      message: 'Credential Types not found',
      statusCode: 401,
    });

    expect(error.payload).toBe('{"details":"payload"}');
    expect(error.error).toBe('invalid_request');
    expect(error.errorCode).toBe('sdk_error');
    expect(error.requestId).toBe('request-123');
    expect(error.message).toBe('Credential Types not found');
    expect(error.statusCode).toBe(401);
  });

  it('parses structured native error payloads from a marked bridged error', () => {
    const error = VCLErrorDeserializer.fromJsonString(
      JSON.stringify({
        payload: '{"details":"payload"}',
        error: 'invalid_request',
        errorCode: 'sdk_error',
        requestId: 'request-123',
        message: 'Credential Types not found',
        statusCode: '401',
      })
    );

    expect(error.payload).toBe('{"details":"payload"}');
    expect(error.error).toBe('invalid_request');
    expect(error.errorCode).toBe('sdk_error');
    expect(error.requestId).toBe('request-123');
    expect(error.message).toBe('Credential Types not found');
    expect(error.statusCode).toBe(401);
  });

  it('leaves missing statusCode undefined', () => {
    const error = VCLErrorDeserializer.fromJsonString(
      JSON.stringify({
        errorCode: 'sdk_error',
        message: 'No status code provided',
      })
    );

    expect(error.statusCode).toBeUndefined();
  });

  it('exports the bridge marker constant', () => {
    expect(BRIDGED_VCL_ERROR_CODE).toBe('VCL_BRIDGED_ERROR_V1');
  });
});
