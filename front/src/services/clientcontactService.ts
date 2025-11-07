import { $api } from '@/utils/api'

export default {

  getClientContacts(clientId: number) {
    return $api('/client-contacts', { 
      params: { client_id: clientId } 
    })
  },
  

  getContactsByClient(clientId: number) {
    return $api('/client-contacts', {
      params: { client_id: clientId }
    })
  },
  

  getContactById(id: number) {
    return $api(`/client-contacts/${id}`)
  },
  

  createContact(contactData: any) {
    return $api('/client-contacts', {
      method: 'POST',
      body: contactData
    })
  },
  
 
  updateContact(id: number, contactData: any) {
    return $api(`/client-contacts/${id}`, {
      method: 'PUT',
      body: contactData
    })
  },
  
  
  deleteContact(id: number) {
    return $api(`/client-contacts/${id}`, {
      method: 'DELETE'
    })
  }
}