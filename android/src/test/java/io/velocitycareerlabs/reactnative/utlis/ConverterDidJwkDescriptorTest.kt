/**
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative.utlis

import com.facebook.react.bridge.JavaOnlyMap
import com.nimbusds.jose.JWSAlgorithm
import com.nimbusds.jose.jwk.Curve
import io.velocitycareerlabs.api.VCLSignatureAlgorithm
import io.velocitycareerlabs.api.entities.error.VCLError
import io.velocitycareerlabs.api.entities.error.VCLErrorCode
import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class ConverterDidJwkDescriptorTest {

  @Test
  fun es256AliasResolvesToEs256() {
    assertP256(signatureAlgorithmOf("ES256"))
  }

  @Test
  fun es256kAliasResolvesToSecp256k1() {
    assertSecp256k1(signatureAlgorithmOf("ES256K"))
  }

  @Test
  fun missingDescriptorResolvesToEs256() {
    assertP256(Converter.mapToDidJwkDescriptor(null).signatureAlgorithm)
  }

  @Test
  fun missingSignatureAlgorithmResolvesToEs256() {
    assertP256(Converter.mapToDidJwkDescriptor(JavaOnlyMap()).signatureAlgorithm)
  }

  @Test
  fun nonStringSignatureAlgorithmIsRejected() {
    val error = assertThrows(VCLError::class.java) {
      Converter.mapToDidJwkDescriptor(JavaOnlyMap.of("signatureAlgorithm", 256.0))
    }

    assertEquals(VCLErrorCode.SdkError.value, error.errorCode)
    assertEquals(
      "Unsupported signatureAlgorithm (non-string value). Expected one of: ES256, P-256, ES256K, secp256k1.",
      error.message
    )
  }

  @Test
  fun nullSignatureAlgorithmResolvesToEs256() {
    assertP256(signatureAlgorithmOf(null))
  }

  @Test
  fun p256ResolvesToEs256() {
    assertP256(signatureAlgorithmOf("P-256"))
  }

  @Test
  fun remoteCryptoServicesTokenIsPreserved() {
    val didJwkDescriptor = Converter.mapToDidJwkDescriptor(
      JavaOnlyMap.of(
        "signatureAlgorithm", "ES256",
        "remoteCryptoServicesToken", JavaOnlyMap.of("value", "remote-token")
      )
    )

    assertP256(didJwkDescriptor.signatureAlgorithm)
    assertEquals("remote-token", didJwkDescriptor.remoteCryptoServicesToken?.value)
  }

  @Test
  fun secp256k1ResolvesToSecp256k1() {
    assertSecp256k1(signatureAlgorithmOf("secp256k1"))
  }

  @Test
  fun unknownSignatureAlgorithmIsRejected() {
    listOf("", "es256", "P-384", "RS256").forEach { value ->
      val error = assertThrows(VCLError::class.java) { signatureAlgorithmOf(value) }

      assertEquals(VCLErrorCode.SdkError.value, error.errorCode)
      assertEquals(
        "Unsupported signatureAlgorithm \"$value\". Expected one of: ES256, P-256, ES256K, secp256k1.",
        error.message
      )
    }
  }

  private fun signatureAlgorithmOf(value: String?) =
    Converter.mapToDidJwkDescriptor(JavaOnlyMap.of("signatureAlgorithm", value)).signatureAlgorithm

  private fun assertP256(signatureAlgorithm: VCLSignatureAlgorithm) {
    assertEquals(VCLSignatureAlgorithm.ES256, signatureAlgorithm)
    assertEquals(Curve.P_256, signatureAlgorithm.curve)
    assertEquals(JWSAlgorithm.ES256, signatureAlgorithm.jwsAlgorithm)
  }

  private fun assertSecp256k1(signatureAlgorithm: VCLSignatureAlgorithm) {
    assertEquals(VCLSignatureAlgorithm.SECP256k1, signatureAlgorithm)
    assertEquals(Curve.SECP256K1, signatureAlgorithm.curve)
    assertEquals(JWSAlgorithm.ES256K, signatureAlgorithm.jwsAlgorithm)
  }
}
