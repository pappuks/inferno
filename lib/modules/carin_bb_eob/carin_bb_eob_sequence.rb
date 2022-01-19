# frozen_string_literal: true

module Inferno
    module Sequence
      class CarinBlueButtonExplanationOfBenefitSequence < SequenceBase
        group 'Carin BlueButton EOB Profile Conformance'
  
        title 'ExplanationOfBenefit'
  
        description 'Verify that ExplanationOfBenefit resources on the FHIR server conform to the Carin BlueButton Implementation Guide'
  
        test_id_prefix 'CBBEB'
  
        requires :token, :patient_id
  
        def validate_resource_item(resource, property, value)
          case property
          when 'patient'
            assert resource.patient&.reference&.include?(value), 'Patient on resource does not match patient requested'
          end
        end
  
        test 'Server rejects ExplanationOfBenefit search without authorization' do
          metadata do
            id '01'
            link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
            description %(
            )
            versions :r4
          end
  
          #skip_if_not_supported(:ExplanationOfBenefit, [:search, :read])
  
          @client.set_no_auth
          skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?
  
          reply = get_resource_by_params(versioned_resource_class('ExplanationOfBenefit'), patient: @instance.patient_id)
          @client.set_bearer_token(@instance.token)
          assert_response_unauthorized reply
        end
  
        test 'Server returns expected results from ExplanationOfBenefit search by patient' do
          metadata do
            id '02'
            link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
            description %(
            )
            versions :r4
          end
  
          #skip_if_not_supported(:ExplanationOfBenefit, [:search, :read])
  
          search_params = { patient: @instance.patient_id }
          reply = get_resource_by_params(versioned_resource_class('ExplanationOfBenefit'), search_params)
          # save resources even if validation fails
          save_resource_ids_in_bundle(versioned_resource_class('ExplanationOfBenefit'), reply)
          validate_search_reply(versioned_resource_class('ExplanationOfBenefit'), reply, search_params)
          #save_resource_ids_in_bundle(versioned_resource_class('ExplanationOfBenefit'), reply)
        end
  
        test 'ExplanationOfBenefit resources associated with Patient conform to EOB Inpatient Institutional profile' do
          metadata do
            id '03'
            link 'http://www.fhir.org/guides/argonaut/r2/StructureDefinition-argo-smokingstatus.html'
            description %(
            )
            versions :r4
          end
          test_resources_against_profile('ExplanationOfBenefit', Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:inpatient_institutional])
          skip_unless @profiles_encountered.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:inpatient_institutional]), 'No inpatient institutional ExplanationOfBenefits found.'
          assert !@profiles_failed.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:inpatient_institutional]), "inpatient institutional ExplanationOfBenefits failed validation.<br/>#{@profiles_failed[Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:inpatient_institutional]]}"
        end
  
        test 'ExplanationOfBenefit resources associated with Patient conform to EOB oral profile' do
          metadata do
            id '04'
            link 'http://www.fhir.org/guides/argonaut/r2/StructureDefinition-argo-smokingstatus.html'
            description %(
            )
            versions :r4
          end
          test_resources_against_profile('ExplanationOfBenefit', Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:oral])
          skip_unless @profiles_encountered.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:oral]), 'No Oral ExplanationOfBenefits found.'
          assert !@profiles_failed.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:oral]), "Oral ExplanationOfBenefits failed validation.<br/>#{@profiles_failed[Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:oral]]}"
        end
  
        test 'ExplanationOfBenefit resources associated with Patient conform to EOB Outpatient Institutional profile' do
          metadata do
            id '05'
            link 'http://www.fhir.org/guides/argonaut/r2/StructureDefinition-argo-smokingstatus.html'
            description %(
            )
            versions :r4
          end
          test_resources_against_profile('ExplanationOfBenefit', Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:outpatient_institutional])
          skip_unless @profiles_encountered.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:outpatient_institutional]), 'No Outpatient Institutional ExplanationOfBenefits found.'
          assert !@profiles_failed.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:outpatient_institutional]), "Outpatient Institutional ExplanationOfBenefits failed validation.<br/>#{@profiles_failed[Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:outpatient_institutional]]}"
        end
  
        test 'ExplanationOfBenefit resources associated with Patient conform to EOB pharmacy profile' do
          metadata do
            id '06'
            link 'http://www.fhir.org/guides/argonaut/r2/StructureDefinition-argo-smokingstatus.html'
            description %(
            )
            versions :r4
          end
          test_resources_against_profile('ExplanationOfBenefit', Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:pharmacy])
          skip_unless @profiles_encountered.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:pharmacy]), 'No pharmacy ExplanationOfBenefits found.'
          assert !@profiles_failed.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:pharmacy]), "pharmacy ExplanationOfBenefits failed validation.<br/>#{@profiles_failed[Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:pharmacy]]}"
        end
  
        test 'ExplanationOfBenefit resources associated with Patient conform to EOB professional non clinicain profile' do
          metadata do
            id '07'
            link 'http://www.fhir.org/guides/argonaut/r2/StructureDefinition-argo-smokingstatus.html'
            description %(
            )
            versions :r4
          end
          test_resources_against_profile('ExplanationOfBenefit', Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:professional_nonclinician])
          skip_unless @profiles_encountered.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:professional_nonclinician]), 'No professional non clinicain ExplanationOfBenefits found.'
          assert !@profiles_failed.include?(Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:professional_nonclinician]), "professional non clinicain ExplanationOfBenefits failed validation.<br/>#{@profiles_failed[Inferno::ValidationUtil::CARIN_BB_EOB_URIS[:professional_nonclinician]]}"
        end
      end
    end
  end
  