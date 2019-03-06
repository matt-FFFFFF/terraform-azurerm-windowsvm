output "virtual_machine_ids" {
  description = "The created VM IDs"
  value       = azurerm_virtual_machine.vm.*.id
}

