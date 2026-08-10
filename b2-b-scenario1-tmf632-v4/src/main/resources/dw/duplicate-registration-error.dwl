%dw 2.0
output application/json
---
{
  code: "ERR_DUPLICATE_REGISTRATION_NUMBER",
  reason: "Entity with registration number 40003987654 already exists.",
  message: "Legal Entity duplication prevented. Registration number '40003987654' is already assigned to 'AlphaConsult SIA' (ID: org-alpha-9901).",
  status: "409",
  referenceError: "https://api.telecom.com/errors/ERR_DUPLICATE_REGISTRATION_NUMBER"
}
