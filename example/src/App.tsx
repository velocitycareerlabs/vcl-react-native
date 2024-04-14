/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';

import vcl, {
  type VCLCountries,
  VCLCountryCodes,
  type VCLCredentialManifest,
  type VCLCredentialManifestDescriptorByDeepLink,
  type VCLCredentialManifestDescriptorByService,
  type VCLCredentialManifestDescriptorRefresh,
  type VCLCredentialTypeSchemas,
  type VCLCredentialTypesUIFormSchema,
  type VCLCredentialTypesUIFormSchemaDescriptor,
  VCLEnvironment,
  type VCLExchange,
  type VCLExchangeDescriptor,
  type VCLFinalizeOffersDescriptor,
  type VCLGenerateOffersDescriptor,
  type VCLJwt,
  type VCLJwtVerifiableCredentials,
  type VCLOffers,
  type VCLOrganizations,
  type VCLPresentationRequest,
  type VCLPresentationSubmission,
  type VCLSubmissionResult,
  type VCLService,
  type VCLServiceCredentialAgentIssuer,
  type VCLToken,
  type VCLVerifiedProfile,
  type VCLDeepLink,
  type VCLInitializationDescriptor,
  type VCLPresentationRequestDescriptor,
  type VCLDidJwk,
  type VCLError,
  type VCLCredentialTypes,
  VCLStatusCode,
  VCLXVnfProtocolVersion,
  VCLCryptoServiceType,
  VCLSignatureAlgorithm,
  type VCLDidJwkDescriptor,
} from '@velocitycareerlabs/vcl-react-native';
import { useRef } from 'react';
import { Utils } from './Utils';
import { Constants } from './Constants';

export const enum InitState {
  Initializing,
  InitializationSucceed,
  InitializationFailed,
}

const environment = VCLEnvironment.Dev;

const didJwkDescriptor: VCLDidJwkDescriptor = {
  signatureAlgorithm: VCLSignatureAlgorithm.ES256,
};

export default () => {
  const didJwkRef = useRef(null as unknown as VCLDidJwk);

  const [initState, setInitState] = React.useState<InitState>(
    InitState.Initializing
  );
  const [error, setError] = React.useState<VCLError>();

  React.useEffect(() => {
    setInitState(InitState.Initializing);

    const initializationDescriptor: VCLInitializationDescriptor = {
      environment,
      xVnfProtocolVersion: VCLXVnfProtocolVersion.XVnfProtocolVersion2,
      cacheSequence: 0,
      cryptoServicesDescriptor: {
        cryptoServiceType: VCLCryptoServiceType.Remote,
        remoteCryptoServicesUrlsDescriptor: {
          keyServiceUrls: {
            createDidKeyServiceUrl:
              Constants.getCreateDidKeyServiceUrl(environment),
          },
          jwtServiceUrls: {
            jwtSignServiceUrl: Constants.getJwtSignServiceUrl(environment),
            jwtVerifyServiceUrl: Constants.getJwtVerifyServiceUrl(environment),
          },
        },
      },
    };
    vcl.initialize(initializationDescriptor).then(
      () => {
        console.log('VCL initialization succeed!');

        vcl.generateDidJwk(didJwkDescriptor).then(
          (resDidJwk: VCLDidJwk) => {
            didJwkRef.current = resDidJwk;
            console.log(`VCL did:jwk is ${JSON.stringify(didJwkRef.current)}`);
            setInitState(InitState.InitializationSucceed);
          },
          (err: VCLError) => {
            console.log(
              'VCL Failed to generate did:jwk with error:',
              JSON.stringify(err)
            );
            setInitState(InitState.InitializationFailed);
            setError(err);
          }
        );
      },
      (err: VCLError) => {
        console.log('VCL Initialization with error:', JSON.stringify(err));
        setInitState(InitState.InitializationFailed);
        setError(err);
      }
    );
  }, []);

  const getCountries = () => {
    vcl.getCountries().then(
      (countries: VCLCountries) => {
        console.log('VCL Countries received:', JSON.stringify(countries));
      },
      (err: VCLError) => {
        console.log('VCL getCountries Error:', JSON.stringify(err));
      }
    );
  };

  const getCredentialTypeSchemas = () => {
    vcl.getCredentialTypeSchemas().then(
      (credentialTypesScemas: VCLCredentialTypeSchemas) => {
        console.log(
          'VCL Credential type schemas received:',
          JSON.stringify(credentialTypesScemas)
        );
      },
      (err: VCLError) => {
        console.log('VCL getCredentialTypeSchemas Error:', JSON.stringify(err));
      }
    );
  };

  const getCredentialTypes = () => {
    vcl.getCredentialTypes().then(
      (credentialTypes: VCLCredentialTypes) => {
        console.log(
          'VCL Credential Types received:',
          JSON.stringify(credentialTypes)
        );
      },
      (err: VCLError) => {
        console.log('VCL getCredentialTypeSchemas Error:', JSON.stringify(err));
      }
    );
  };

  const getPresentationRequest = () => {
    let deepLink: VCLDeepLink = {
      value: Constants.PresentationRequestDeepLinkStrDev,
    };
    if (environment === VCLEnvironment.Staging.valueOf()) {
      deepLink = {
        value: Constants.PresentationRequestDeepLinkStrStaging,
      };
    }
    const pesentationRequestDescriptor: VCLPresentationRequestDescriptor = {
      deepLink,
      pushDelegate: {
        pushToken: 'push_token',
        pushUrl: 'push_delegate',
      },
      didJwk: didJwkRef.current,
    };
    vcl.getPresentationRequest(pesentationRequestDescriptor).then(
      (presentationRequest: VCLPresentationRequest) => {
        console.log(
          'VCL Presentation Request received:',
          JSON.stringify(presentationRequest)
        );
        submitPresentation(presentationRequest);
      },
      (err: VCLError) => {
        if (err.statusCode === VCLStatusCode.VerificationError) {
          console.log(
            'VCL Presentation Request service type VERIFICATION failed:',
            JSON.stringify(err)
          );
        } else {
          console.log('VCL Presentation Request failed:', JSON.stringify(err));
        }
      }
    );
  };

  const submitPresentation = (presentationRequest: VCLPresentationRequest) => {
    const presentationSubmission: VCLPresentationSubmission = {
      presentationRequest,
      verifiableCredentials: Constants.PresentationSelectionsList,
    };
    vcl.submitPresentation(presentationSubmission).then(
      (presentationSubmissionResult: VCLSubmissionResult) => {
        console.log(
          'VCL Presentation submission result:',
          JSON.stringify(presentationSubmissionResult)
        );

        const exchangeDescriptor: VCLExchangeDescriptor = {
          presentationSubmission,
          submissionResult: presentationSubmissionResult,
        };

        vcl.getExchangeProgress(exchangeDescriptor).then(
          (exchange: VCLExchange) => {
            console.log(
              'VCL Presentation submission progress:',
              JSON.stringify(exchange)
            );
          },
          (err: VCLError) => {
            console.log(
              'VCL Presentation submission progress failed:',
              JSON.stringify(err)
            );
          }
        );
      },
      (err: VCLError) => {
        console.log('VCL Presentation submission failed:', JSON.stringify(err));
      }
    );
  };

  const getOrganizationsThenCredentialManifestByService = () => {
    searchForOrganizations();
  };

  const searchForOrganizations = () => {
    let organizationDescriptor =
      Constants.OrganizationsSearchDescriptorByDidDev;
    if (environment === VCLEnvironment.Staging.valueOf()) {
      organizationDescriptor =
        Constants.OrganizationsSearchDescriptorByDidStaging;
    }
    vcl.searchForOrganizations(organizationDescriptor).then(
      (organizations: VCLOrganizations) => {
        console.log(
          'VCL Organizations received:',
          JSON.stringify(organizations)
        );

        const serviceCredentialAgentIssuer: VCLServiceCredentialAgentIssuer = {
          payload:
            organizations.all[0]?.serviceCredentialAgentIssuers[0]?.payload ??
            {},
        };
        getCredentialManifestByService(serviceCredentialAgentIssuer);
      },
      (err: VCLError) => {
        console.log('VCL Organizations search failed: ', JSON.stringify(err));
      }
    );
  };

  const getCredentialManifestByService = (
    serviceCredentialAgentIssuer: VCLServiceCredentialAgentIssuer
  ) => {
    const credentialManifestDescriptorByOrganization: VCLCredentialManifestDescriptorByService =
      {
        service: serviceCredentialAgentIssuer,
        credentialTypes: [
          'CertificationV1.0',
          'EducationDegreeStudyV1.0',
          'EducationDegreeRegistrationV1.0',
        ],
        didJwk: didJwkRef.current,
      };
    vcl.getCredentialManifest(credentialManifestDescriptorByOrganization).then(
      (credentialManifest: VCLCredentialManifest) => {
        console.log(
          'VCL Credential Manifest received:',
          JSON.stringify(credentialManifest)
        );
        generateOffers(credentialManifest);
      },
      (err: VCLError) => {
        if (err.statusCode === VCLStatusCode.VerificationError) {
          console.log(
            'VCL Credential Manifest service type VERIFICATION failed:',
            JSON.stringify(err)
          );
        } else {
          console.log('VCL Credential Manifest failed:', JSON.stringify(err));
        }
      }
    );
  };

  const getCredentialManifestByDeepLink = () => {
    let deepLink: VCLDeepLink = {
      value: Constants.CredentialManifestDeepLinkStrDev,
    };
    if (environment === VCLEnvironment.Staging.valueOf()) {
      deepLink = {
        value: Constants.CredentialManifestDeepLinkStrStaging,
      };
    }
    const credentialManifestDescriptorByDeepLink: VCLCredentialManifestDescriptorByDeepLink =
      {
        deepLink,
        didJwk: didJwkRef.current,
      };
    vcl.getCredentialManifest(credentialManifestDescriptorByDeepLink).then(
      (credentialManifest: VCLCredentialManifest) => {
        console.log(
          'VCL Credential Manifest received:',
          JSON.stringify(credentialManifest)
        );
        generateOffers(credentialManifest);
      },
      (err: VCLError) => {
        if (err.statusCode === VCLStatusCode.VerificationError) {
          console.log(
            'VCL Credential Manifest service type VERIFICATION failed:',
            JSON.stringify(err)
          );
        } else {
          console.log('VCL Credential Manifest failed:', JSON.stringify(err));
        }
      }
    );
  };

  const refreshCredentials = () => {
    const service: VCLService = {
      payload: JSON.parse(Constants.IssuingServiceJsonStr),
    };
    const credentialManifestDescriptorRefresh: VCLCredentialManifestDescriptorRefresh =
      {
        service,
        credentialIds: Constants.CredentialIdsToRefresh,
        didJwk: didJwkRef.current,
      };
    vcl.getCredentialManifest(credentialManifestDescriptorRefresh).then(
      (credentialManifest: VCLCredentialManifest) => {
        console.log(
          `VCL Credentials refreshed, credential manifest: ${JSON.stringify(credentialManifest)}`
        );
      },
      (err: VCLError) => {
        if (err.statusCode === VCLStatusCode.VerificationError) {
          console.log(
            'VCL Refresh Credentials service type VERIFICATION failed:',
            JSON.stringify(err)
          );
        } else {
          console.log('VCL Refresh Credentials failed:', JSON.stringify(err));
        }
      }
    );
  };

  const generateOffers = (credentialManifest: VCLCredentialManifest) => {
    const generateOffersDescriptor: VCLGenerateOffersDescriptor = {
      credentialManifest,
      types: Constants.CredentialTypes,
      identificationVerifiableCredentials: Constants.IdentificationList,
    };

    vcl.generateOffers(generateOffersDescriptor).then(
      (offers: VCLOffers) => {
        console.log(
          `VCL Generated Offers: ${offers.all.map((o) =>
            JSON.stringify(o.payload)
          )}`
        );
        console.log(
          `VCL Generated Offers Response Code: ${offers.responseCode}`
        );
        console.log(
          `VCL Generated Offers Session Token value: ${offers.sessionToken.value}`,
          `VCL Generated Offers Session Token expires in: ${offers.sessionToken.expiresIn}`
        );

        // Check offers invoked after the push notification is notified the app that offers are ready:
        checkForOffers(
          credentialManifest,
          generateOffersDescriptor,
          offers.sessionToken
        );
      },
      (err: VCLError) => {
        console.log('VCL generateOffers Error:', JSON.stringify(err));
      }
    );
  };

  const checkForOffers = (
    credentialManifest: VCLCredentialManifest,
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    sessionToken: VCLToken
  ) => {
    vcl.checkForOffers(generateOffersDescriptor, sessionToken).then(
      (offers: VCLOffers) => {
        console.log(
          `VCL Checked Offers: ${offers.all.map((o) =>
            JSON.stringify(o.payload)
          )}`
        );
        console.log(`VCL Checked Offers Response Code: ${offers.responseCode}`);
        console.log(
          `VCL Checked Offers Session Token value: ${offers.sessionToken.value}`,
          `VCL Checked Offers Session Token expires in: ${offers.sessionToken.expiresIn}`
        );
        if (offers.responseCode === 200) {
          finalizeOffers(credentialManifest, offers);
        } else {
          console.log(
            `VCL Failed to Check Offers with response code: ${offers.responseCode}`
          );
        }
      },
      (err: VCLError) => {
        console.log(`VCL failed to Check Offers: ${err}`);
      }
    );
  };

  const finalizeOffers = (
    credentialManifest: VCLCredentialManifest,
    generatedOffers: VCLOffers
  ) => {
    const approvedRejectedOfferIds =
      Utils.getApprovedRejectedOfferIdsMock(generatedOffers);
    const finalizeOffersDescriptor: VCLFinalizeOffersDescriptor = {
      credentialManifest,
      offers: generatedOffers,
      approvedOfferIds: approvedRejectedOfferIds[0]!,
      rejectedOfferIds: approvedRejectedOfferIds[1]!,
    };
    vcl
      .finalizeOffers(finalizeOffersDescriptor, generatedOffers.sessionToken)
      .then(
        (jwtVerifiableCredentials: VCLJwtVerifiableCredentials) => {
          console.log(
            'VCL Finalized Offers received:',
            JSON.stringify(jwtVerifiableCredentials)
          );
          console.log('VCL finalized Offers');
          console.log(
            'VCL Passed Credentials:',
            JSON.stringify(jwtVerifiableCredentials.passedCredentials)
          );
          console.log(
            'VCL Failed Credentials:',
            JSON.stringify(jwtVerifiableCredentials.failedCredentials)
          );
        },
        (err: VCLError) => {
          console.log('VCL finalizeOffers Error:', err);
        }
      );
  };

  const getCredentialTypesUIFormSchema = () => {
    const credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor =
      {
        credentialType: Constants.ResidentPermitV10,
        countryCode: VCLCountryCodes.CA,
      };
    vcl
      .getCredentialTypesUIFormSchema(credentialTypesUIFormSchemaDescriptor)
      .then(
        (credentialTypesUIFormSchema: VCLCredentialTypesUIFormSchema) => {
          console.log(
            'VCL Credential Types UI Form Schema received:',
            JSON.stringify(credentialTypesUIFormSchema)
          );
        },
        (err: VCLError) => {
          console.log(
            'VCL getCredentialTypesFormSchema Error:',
            JSON.stringify(err)
          );
        }
      );
  };

  const getVerifiedProfile = () => {
    vcl.getVerifiedProfile(Constants.VerifiedProfileDescriptor).then(
      (verifiedProfile: VCLVerifiedProfile) => {
        console.log('VCL Verified Profile: ', JSON.stringify(verifiedProfile));
      },
      (err: VCLError) => {
        if (err.statusCode === VCLStatusCode.VerificationError) {
          console.log(
            'VCL Profile verification failed dwith error:',
            JSON.stringify(err)
          );
        } else {
          console.log('VCL Verified profile failed:', JSON.stringify(err));
        }
      }
    );
  };

  const verifyJwt = () => {
    vcl.verifyJwt(Constants.SomeJwt, Constants.SomeJwkPublic).then(
      (isVerified: boolean) => {
        console.log('VCL verified jwt:', isVerified);
      },
      (err: VCLError) => {
        console.log('VCL verify Error:', JSON.stringify(err));
      }
    );
  };

  const generateSignedJwt = () => {
    vcl
      .generateSignedJwt(
        {
          payload: Constants.SomePayload,
          iss: 'iss123',
          jti: 'jti123',
        },
        didJwkRef.current
      )
      .then(
        (jwt: VCLJwt) => {
          console.log('VCL generated signed jwt:', JSON.stringify(jwt));
        },
        (err: VCLError) => {
          console.log('VCL sign Error:', JSON.stringify(err));
        }
      );
  };

  const generateDidJwk = () => {
    vcl.generateDidJwk(didJwkDescriptor).then(
      (resDidJwk: VCLDidJwk) => {
        didJwkRef.current = resDidJwk;
        console.log('VCL did:jwk generated: ', JSON.stringify(resDidJwk));
      },
      (err: VCLError) => {
        console.log('VCL did:jwk generation failed:', JSON.stringify(err));
      }
    );
  };

  if (initState === InitState.InitializationSucceed) {
    return (
      <View style={styles.container}>
        <View style={styles.space} />
        <Button title="getCountries" onPress={getCountries} />
        <View style={styles.space} />
        <Button title="getCredentialTypes" onPress={getCredentialTypes} />
        <View style={styles.space} />
        <Button
          title="getCredentialTypeSchemas"
          onPress={getCredentialTypeSchemas}
        />
        <View style={styles.space} />
        <Button
          title="Disclosing Credentials (aka Inspection)"
          onPress={getPresentationRequest}
        />
        <View style={styles.space} />
        <Button
          title="Receiving Credentials (aka Issuing) By Deeplink"
          onPress={getCredentialManifestByDeepLink}
        />
        <View style={styles.space} />
        <Button
          title="Receiving Credentials (aka Issuing) By Services"
          onPress={getOrganizationsThenCredentialManifestByService}
        />
        <View style={styles.space} />
        <Button
          title="Self Reporting Credentials (aka Self Attested)"
          onPress={getCredentialTypesUIFormSchema}
        />
        <View style={styles.space} />
        <Button title="Refresh Credentials" onPress={refreshCredentials} />
        <View style={styles.space} />
        <Button title="Get Verified Profile" onPress={getVerifiedProfile} />
        <View style={styles.space} />
        <Button title="Verify Jwt" onPress={verifyJwt} />
        <View style={styles.space} />
        <Button title="Generate Signed Jwt" onPress={generateSignedJwt} />
        <View style={styles.space} />
        <Button title="Generate DID:JWK" onPress={generateDidJwk} />
      </View>
    );
  } if (initState === InitState.InitializationFailed) {
    return (
      <View style={styles.container}>
        <Text>Initialization Failed</Text>
        <Text>{JSON.stringify(error)}</Text>
      </View>
    );
  } 
    return (
      <View style={styles.container}>
        <Text>Initializing...</Text>
      </View>
    );
  
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  space: {
    width: 5, // or whatever size you need
    height: 5,
  },
});
