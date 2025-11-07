import { $api } from '@/utils/api'

export default {
  /**
   * Get all contacts for a client
   */
  getClientContacts(clientId: number) {
    return $api('/client-contacts', { 
      params: { client_id: clientId } 
    })
  },
  
  /**
   * Get all contacts for a client (using route parameter instead of query parameter)
   * This matches the function called in the view page
   */
  getContactsByClient(clientId: number) {
    return $api('/client-contacts', {
      params: { client_id: clientId }
    })
  },
  
  /**
   * Get a specific contact by ID
   */
  getContactById(id: number) {
    return $api(`/client-contacts/${id}`)
  },
  
  /**
   * Create a new client contact
   */
  createContact(contactData: any) {
    return $api('/client-contacts', {
      method: 'POST',
      body: contactData
    })
  },
  
  /**
   * Update an existing contact
   */
  updateContact(id: number, contactData: any) {
    return $api(`/client-contacts/${id}`, {
      method: 'PUT',
      body: contactData
    })
  },
  
  /**
   * Delete a contact
   */
  deleteContact(id: number) {
    return $api(`/client-contacts/${id}`, {
      method: 'DELETE'
    })
  }
}