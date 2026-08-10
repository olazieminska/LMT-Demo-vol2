%dw 2.0
output application/json
fun mergePatch(target, patch) =
  if (!(patch is Object)) patch
  else do {
    var baseObj = if (target is Object) target else {}
    ---
    (
      baseObj
      -- ((patch pluck ((value, key) -> key)) filter (key) -> patch[key] == null)
    )
    ++
    (patch mapObject ((value, key) ->
      (key): if (value == null)
               null
             else
               mergePatch(baseObj[key], value)
    ))
    -- ((patch pluck ((value, key) -> key)) filter (key) -> patch[key] == null)
  }

var baseline = {
  id: "org-alpha-9901",
  href: "/tmf-api/party/v4/organization/org-alpha-9901",
  "@type": "Organization",
  "@baseType": "Party",
  name: "AlphaConsult SIA",
  tradingName: "AlphaConsult Logistics",
  nameType: "Legal Name",
  organizationType: "Company",
  isHeadOffice: true,
  isLegalEntity: true,
  status: "initialized",
  organizationIdentification: [
    {
      "@type": "OrganizationIdentification",
      identificationId: "40003987654",
      identificationType: "RegistrationNumber",
      issuingAuthority: "Register of Enterprises of the Republic of Latvia",
      issuingDate: "2022-05-10T00:00:00Z"
    }
  ],
  relatedParty: [
    {
      "@type": "PartyRef",
      "@referredType": "Individual",
      id: "ind-janis-8821",
      href: "/tmf-api/party/v4/individual/ind-janis-8821",
      name: "Jānis Bērziņš",
      role: "LegalRepresentative"
    }
  ],
  contactMedium: [
    {
      "@type": "ContactMedium",
      mediumType: "PostalAddress",
      preferred: true,
      characteristic: {
        "@type": "PostalAddress",
        contactType: "Legal Address",
        street1: "Kārļa Ulmaņa gatve 114",
        street2: "Building B, Floor 2",
        city: "Rīga",
        postCode: "LV-1046",
        country: "Latvia"
      }
    },
    {
      "@type": "ContactMedium",
      mediumType: "Email",
      preferred: true,
      characteristic: {
        "@type": "EmailContact",
        contactType: "Corporate Email",
        emailAddress: "info@alphaconsult.lv"
      }
    }
  ],
  partyCharacteristic: [
    {
      "@type": "PartyCharacteristic",
      name: "employeeCount",
      valueType: "integer",
      value: "12"
    },
    {
      "@type": "PartyCharacteristic",
      name: "industrySegment",
      valueType: "string",
      value: "Logistics & Freight Forwarding"
    }
  ]
}
var current = vars.existingRecord default baseline
var merged = mergePatch(current, vars.patchPayload default {})
---
if ((attributes.queryParams.enrichFromRegister default "false") == "true")
  merged ++ {
    status: "validated",
    vatNumber: "LV40003987654",
    externalReference: (merged.externalReference default []) ++ [
      {
        "@type": "ExternalReference",
        externalReferenceType: "BusinessRegister",
        name: "UR Legal Entity Profile",
        url: "https://info.ur.gov.lv/legal_entity/40003987654"
      }
    ]
  }
else
  merged
