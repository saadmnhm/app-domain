import { $api } from '@/utils/api'

export default {

  getClients(params: any = {}) {
    return $api('/clients', { params })
  },
  
  
  getClientById(id: any) {
    return $api(`/clients/${id}`)
  },
  
 
  createClient(clientData: any) {
    return $api('/clients', {
      method: 'POST',
      body: clientData
    })
  },

 
  updateClient(id: any, clientData: any) {
    return $api(`/clients/${id}`, {
      method: 'PUT',
      body: clientData
    })
  },

  deleteClient(id: any) {
    return $api(`/clients/${id}`, {
      method: 'DELETE'
    })
  }, 

  getClient(id: any) {
    return $api(`/clients/${id}`)
  },
  
 
  getCategories(params = {}) {
    return $api('/categories', { params })
  }
}
