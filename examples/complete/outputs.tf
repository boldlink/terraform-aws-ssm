output "name" {
  value       = module.complete_example_session.name
  description = "Name of the session document"
}

output "document_type" {
  value       = module.complete_example_session.document_type
  description = "The document type"
}

output "name2" {
  value       = module.custom_session.name
  description = "Name of the session document"
}

output "document_type2" {
  value       = module.custom_session.document_type
  description = "The document type"
}
