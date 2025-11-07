import { $api } from '@/utils/api'

export default {
  /**
   * Get all clients with optional filters
   */
  getClients(params: any = {}) {
    return $api('/clients', { params })
  },
  
  /**
   * Get a specific client by ID
   */
  getClientById(id: any) {
    return $api(`/clients/${id}`)
  },
  
  /**
   * Create a new client
   */
  createClient(clientData: any) {
    return $api('/clients', {
      method: 'POST',
      body: clientData
    })
  },

  /**
   * Update an existing client
   */
  updateClient(id: any, clientData: any) {
    return $api(`/clients/${id}`, {
      method: 'PUT',
      body: clientData
    })
  },

  /**
   * Delete a client
   */
  deleteClient(id: any) {
    return $api(`/clients/${id}`, {
      method: 'DELETE'
    })
  }, 
  
  /**
   * Get a specific client by ID
   */
  getClient(id: any) {
    return $api(`/clients/${id}`)
  },
  
  /**
   * Get client categories
   */
  getCategories(params = {}) {
    return $api('/categories', { params })
  }
}
