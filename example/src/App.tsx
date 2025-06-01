/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import * as React from 'react';
import { useRef } from 'react';

import { Button, StyleSheet, Text, View } from 'react-native';

import vcl, {
  type VCLAuthToken,
  VCLCountryCodes,
  type VCLCredentialManifest,
  type VCLCredentialManifestDescriptorByDeepLink,
  type VCLCredentialManifestDescriptorByService,
  type VCLCredentialManifestDescriptorRefresh,
  type VCLCredentialTypeSchemas,
  type VCLCredentialTypesUIFormSchemaDescriptor,
  type VCLDeepLink,
  type VCLDidJwk,
  type VCLDidJwkDescriptor,
  VCLEnvironment,
  type VCLError,
  type VCLExchange,
  type VCLExchangeDescriptor,
  type VCLFinalizeOffersDescriptor,
  type VCLGenerateOffersDescriptor,
  type VCLInitializationDescriptor,
  type VCLOffers,
  type VCLPresentationRequest,
  type VCLPresentationRequestDescriptor,
  type VCLPresentationSubmission,
  type VCLService,
  VCLSignatureAlgorithm,
  VCLStatusCode,
  type VCLToken,
} from '@velocitycareerlabs/vcl-react-native';
import { Constants } from './Constants';
import { getApprovedRejectedOfferIdsMock, verifyToken } from './Utils';

export const enum InitState {
  Initializing,
  InitializationSucceed,
  InitializationFailed,
}

const environment = VCLEnvironment.Staging;

const didJwkDescriptor: VCLDidJwkDescriptor = {
  signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1,
};

export default () => {
  const didJwkRef = useRef(null as unknown as VCLDidJwk);

  const [initState, setInitState] = React.useState<InitState>(
    InitState.Initializing
  );
  const [initializationError, setInitializationError] = React.useState<VCLError>();

  React.useEffect(() => {
    setInitState(InitState.Initializing);

    // const initializationDescriptor: VCLInitializationDescriptor = {
    //   environment,
    //   xVnfProtocolVersion: VCLXVnfProtocolVersion.XVnfProtocolVersion2,
    //   cacheSequence: 0,
    //   cryptoServicesDescriptor: {
    //     cryptoServiceType: VCLCryptoServiceType.Remote,
    //     remoteCryptoServicesUrlsDescriptor: {
    //       keyServiceUrls: {
    //         createDidKeyServiceUrl:
    //           Constants.getCreateDidKeyServiceUrl(environment),
    //       },
    //       jwtServiceUrls: {
    //         jwtSignServiceUrl: Constants.getJwtSignServiceUrl(environment),
    //         jwtVerifyServiceUrl: Constants.getJwtVerifyServiceUrl(environment),
    //       },
    //     },
    //   },
    // };

    const initialize = async () => {
      const initializationDescriptor: VCLInitializationDescriptor = {
        environment,
      };

      try {
        await vcl.initialize(initializationDescriptor);
        console.log('VCL initialization succeeded!');

        try {
          didJwkRef.current = await vcl.generateDidJwk(didJwkDescriptor);
          console.log(`VCL did:jwk is ${JSON.stringify(didJwkRef.current)}`);
          setInitState(InitState.InitializationSucceed);
        } catch (error: any) {
          console.log(
            'VCL failed to generate did:jwk with error:',
            JSON.stringify(error)
          );
          setInitState(InitState.InitializationFailed);
          setInitializationError(error as VCLError);
        }
      } catch (err: any) {
        console.log('VCL initialization failed with error:', JSON.stringify(err));
        setInitState(InitState.InitializationFailed);
        setInitializationError(err);
      }
    };

    initialize();
  }, []);

  const onGetCountries = async () => {
    try {
      const countries = await vcl.getCountries();
      console.log('VCL Countries received:', JSON.stringify(countries));
    } catch (error: any) {
      console.log('VCL getCountries Error:', JSON.stringify(error));
    }
  };

  const onGetCredentialTypeSchemas = () => {
    vcl.getCredentialTypeSchemas().then(
      (credentialTypesSchemas: VCLCredentialTypeSchemas) => {
        console.log(
          'VCL Credential type schemas received:',
          JSON.stringify(credentialTypesSchemas)
        );
      },
      (error: VCLError) => {
        console.log('VCL getCredentialTypeSchemas Error:', JSON.stringify(error));
      }
    );
  };

  const onGetCredentialTypes = async () => {
    try {
      const credentialTypes = await vcl.getCredentialTypes();
      console.log(
        'VCL Credential Types received:',
        JSON.stringify(credentialTypes)
      );
    } catch (error: any) {
      console.log('VCL getCredentialTypes Error:', JSON.stringify(error));
    }
}

  const onGetPresentationRequest = async () => {
    let deepLink: VCLDeepLink = {
      value: Constants.PresentationRequestDeepLinkStrDev,
    };
    if (environment === VCLEnvironment.Staging.valueOf()) {
      deepLink = {
        value: Constants.PresentationRequestDeepLinkStrStaging,
      };
    }
    const presentationRequestDescriptor: VCLPresentationRequestDescriptor = {
      deepLink,
      pushDelegate: {
        pushToken: 'push_token',
        pushUrl: 'push_delegate',
      },
      didJwk: didJwkRef.current,
    };

    try {
      const presentationRequest = await vcl.getPresentationRequest(presentationRequestDescriptor);
      console.log(
        'VCL Presentation Request received:',
        JSON.stringify(presentationRequest)
      );
      await submitPresentation(presentationRequest);
    } catch (error: any) {
      if (error.statusCode === VCLStatusCode.VerificationError) {
        console.log(
          'VCL Presentation Request service type VERIFICATION failed:',
          JSON.stringify(error)
        );
      } else {
        console.log('VCL Presentation Request failed:', JSON.stringify(error));
      }
    }
  };

  const submitPresentation = async (presentationRequest: VCLPresentationRequest) => {
    const presentationSubmission: VCLPresentationSubmission = {
      presentationRequest,
      verifiableCredentials: Constants.getIdentificationList(environment),
    };
    let authToken: VCLAuthToken | undefined;
    if (presentationRequest.feed) {
      try {
        authToken = await vcl.getAuthToken({ presentationRequest });
        console.log('VCL Auth Token received:', JSON.stringify(authToken));
      } catch (error: any) {
        console.log('VCL getAuthToken Error:', JSON.stringify(error));
      }

      if (!verifyToken(authToken?.accessToken)) {
        console.log('VCL Auth Token is expired');
        try {
          authToken = await vcl.getAuthToken({ presentationRequest });
          console.log('VCL Auth Token received:', JSON.stringify(authToken));
        } catch (error: any) {
          console.log('VCL getAuthToken Error:', JSON.stringify(error));
        }
      }
    }
    const presentationSubmissionResult = await vcl.submitPresentation(presentationSubmission, authToken);
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
      (error: VCLError) => {
        console.log(
          'VCL Presentation submission progress failed:',
          JSON.stringify(error)
        );
      }
    );
  };

  const onGetOrganizationsThenCredentialManifestByService = async () => {
    await searchForOrganizations();
  };

  const searchForOrganizations = async () => {
    const organizationDescriptor =
      environment === VCLEnvironment.Dev.valueOf() ?
        Constants.OrganizationsSearchDescriptorByDidDev :
        Constants.OrganizationsSearchDescriptorByDidStaging;

    try {
      const organizations = await vcl.searchForOrganizations(organizationDescriptor);
      console.log(
        'VCL Organizations received:',
        JSON.stringify(organizations)
      );

      const serviceCredentialAgentIssuer: VCLService = {
        payload:
          organizations.all[0]?.serviceCredentialAgentIssuers[0]?.payload ??
          {},
      };
      await getCredentialManifestByService(serviceCredentialAgentIssuer);
    } catch (error: any) {
      console.log('VCL Organizations search failed: ', JSON.stringify(error));
    }
  }

  const getCredentialManifestByService = async (
    serviceCredentialAgentIssuer: VCLService
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

    try {
      const credentialManifest = await vcl.getCredentialManifest(
        credentialManifestDescriptorByOrganization
      );
      console.log(
        'VCL Credential Manifest received:',
        JSON.stringify(credentialManifest)
      );

      await generateOffers(credentialManifest);

    } catch (error: any) {
      if (error.statusCode === VCLStatusCode.VerificationError) {
        console.log(
          'VCL Credential Manifest service type VERIFICATION failed:',
          JSON.stringify(error)
        );
      } else {
        console.log('VCL Credential Manifest failed:', JSON.stringify(error));
      }
    }
  }

  const onGetCredentialManifestByDeepLink = async () => {
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

    try {
      const credentialManifest = await vcl.getCredentialManifest(
        credentialManifestDescriptorByDeepLink
      );
      console.log(
        'VCL Credential Manifest received:',
        JSON.stringify(credentialManifest)
      );
      await generateOffers(credentialManifest);
    } catch (error: any) {
      if (error.statusCode === VCLStatusCode.VerificationError) {
        console.log(
          'VCL Credential Manifest service type VERIFICATION failed:',
          JSON.stringify(error)
        );
      } else {
        console.log('VCL Credential Manifest failed:', JSON.stringify(error));
      }
    }
  }

  const onRefreshCredentials = async () => {
    const service: VCLService = {
      payload: JSON.parse(Constants.IssuingServiceJsonStr),
    };
    const credentialManifestDescriptorRefresh: VCLCredentialManifestDescriptorRefresh =
      {
        service,
        credentialIds: Constants.getCredentialIdsToRefresh(environment),
        didJwk: didJwkRef.current,
      };

    try {
      const credentialManifest = await vcl.getCredentialManifest(
        credentialManifestDescriptorRefresh
      );
      console.log(
        `VCL Credentials refreshed, credential manifest: ${JSON.stringify(credentialManifest)}`
      );
    } catch (error: any) {
      if (error.statusCode === VCLStatusCode.VerificationError) {
        console.log(
          'VCL Refresh Credentials service type VERIFICATION failed:',
          JSON.stringify(error)
        );
      } else {
        console.log('VCL Refresh Credentials failed:', JSON.stringify(error));
      }
    }
  }

  const generateOffers = async (credentialManifest: VCLCredentialManifest) => {
    const generateOffersDescriptor: VCLGenerateOffersDescriptor = {
      credentialManifest,
      types: Constants.CredentialTypes,
      identificationVerifiableCredentials: Constants.getIdentificationList(environment),
    };

    try {
      const offers = await vcl.generateOffers(generateOffersDescriptor);
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
      await checkForOffers(
        credentialManifest,
        generateOffersDescriptor,
        offers.sessionToken
      );
    } catch (error: any) {
      console.log('VCL generateOffers Error:', JSON.stringify(error));
    }
  }

  const checkForOffers = async (
    credentialManifest: VCLCredentialManifest,
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    sessionToken: VCLToken
  ) => {
    try {
      const offers = await vcl.checkForOffers(generateOffersDescriptor, sessionToken);
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
        await finalizeOffers(credentialManifest, offers);
      }
    } catch (error: any) {
      console.log('VCL checkForOffers Error:', JSON.stringify(error));
    }
  }

  const finalizeOffers = async (
    credentialManifest: VCLCredentialManifest,
    offers: VCLOffers
  ) => {
    const approvedRejectedOfferIds = getApprovedRejectedOfferIdsMock(offers);
    const finalizeOffersDescriptor: VCLFinalizeOffersDescriptor = {
      credentialManifest,
      challenge: offers.challenge,
      approvedOfferIds: approvedRejectedOfferIds[0]!,
      rejectedOfferIds: approvedRejectedOfferIds[1]!,
    };

    try {
      const credentials = await vcl.finalizeOffers(finalizeOffersDescriptor, offers.sessionToken)
      console.log(
        'VCL Finalized Offers received:',
        JSON.stringify(credentials)
      );
      console.log('VCL finalized Offers');
      console.log(
        'VCL Passed Credentials:',
        JSON.stringify(credentials.passedCredentials)
      );
      console.log(
        'VCL Failed Credentials:',
        JSON.stringify(credentials.failedCredentials)
      );
    } catch (error: any) {
      console.log('VCL finalizeOffers Error:', JSON.stringify(error));
    }
  }

  const onGetCredentialTypesUIFormSchema = async () => {
    const credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor =
      {
        credentialType: Constants.ResidentPermitV10,
        countryCode: VCLCountryCodes.CA,
      };

    try {
      const credentialTypesUIFormSchema =
        await vcl.getCredentialTypesUIFormSchema(credentialTypesUIFormSchemaDescriptor);
      console.log(
        'VCL Credential Types UI Form Schema received:',
        JSON.stringify(credentialTypesUIFormSchema)
      );
    } catch (error: any) {
      console.log(
        'VCL getCredentialTypesFormSchema Error:',
        JSON.stringify(error)
      );
    }
  }

  const onGetVerifiedProfile = async () => {
    try {
      const verifiedProfile =
        await vcl.getVerifiedProfile(Constants.getVerifiedProfileDescriptor(environment));
      console.log('VCL Verified Profile: ', JSON.stringify(verifiedProfile));

    } catch (error: any) {
      if (error.statusCode === VCLStatusCode.VerificationError) {
        console.log(
          'VCL Profile verification failed with error:',
          JSON.stringify(error)
        );
      } else {
        console.log('VCL Verified profile failed:', JSON.stringify(error));
      }
    }
  }

  const onVerifyJwt = async () => {
    try {
      const isVerified =
        await vcl.verifyJwt(Constants.SomeJwt, Constants.SomeJwkPublic);
      console.log('VCL verified jwt:', isVerified);
    } catch (error: any) {
      console.log('VCL verify Error:', JSON.stringify(error));
    }
  }

  const onGenerateSignedJwt = async () => {
    try {
      const jwt =
        await vcl.generateSignedJwt(
          {
            payload: Constants.SomePayload,
            iss: 'iss123',
            jti: 'jti123',
          },
          didJwkRef.current
        );
      console.log('VCL generated signed jwt:', JSON.stringify(jwt));
      // console.log('VCL generated signed jwt:');
      // console.log('VCL jwt encodedJwt', jwt.encodedJwt);
      // console.log('VCL jwt header', JSON.stringify(jwt.header));
      // console.log('VCL jwt payload:', JSON.stringify(jwt.payload));
      // console.log('VCL jwt signature:', JSON.stringify(jwt.signature));
    } catch (error: any) {
      console.log('VCL sign Error:', JSON.stringify(error));
    }
  }

  const onGenerateDidJwk = async () => {
    try {
      const didJwk = await vcl.generateDidJwk(didJwkDescriptor);
      console.log('VCL did:jwk generated: ', JSON.stringify(didJwk));
    } catch (error: any) {
      console.log('VCL did:jwk generation failed:', JSON.stringify(error));
    }
  }

  const menuItems = {
    'Get Countries': onGetCountries,
    'Get Credential Types': onGetCredentialTypes,
    'Get Credential Type Schemas': onGetCredentialTypeSchemas,
    'Disclosing Credentials (aka Inspection)': onGetPresentationRequest,
    'Receiving Credentials (aka Issuing) By Deeplink':
    onGetCredentialManifestByDeepLink,
    'Receiving Credentials (aka Issuing) By Services':
    onGetOrganizationsThenCredentialManifestByService,
    'Self Reporting Credentials (aka Self Attested)':
    onGetCredentialTypesUIFormSchema,
    'Refresh Credentials': onRefreshCredentials,
    'Get Verified Profile': onGetVerifiedProfile,
    'Verify JWT': onVerifyJwt,
    'Generate Signed JWT': onGenerateSignedJwt,
    'Generate DID:JWK': onGenerateDidJwk,
  };

  const handleClick = (key: string, value: () => void) => {
    if (key !== 'Refresh Credentials') {
      value();
    }
  };

  if (initState === InitState.InitializationSucceed) {
    return (
      <View style={styles.container}>
        <View style={styles.space} />
        {Object.entries(menuItems).map(([key, value]) => (
          <React.Fragment key={key}>
            <Button
              title={key}
              onPress={() => handleClick(key, value)}
              disabled={key === 'Refresh Credentials'}
            />
            <View style={styles.space} />
          </React.Fragment>
        ))}
      </View>
    );
  }
  if (initState === InitState.InitializationFailed) {
    return (
      <View style={styles.container}>
        <Text>Initialization Failed</Text>
        <Text>{JSON.stringify(initializationError)}</Text>
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
