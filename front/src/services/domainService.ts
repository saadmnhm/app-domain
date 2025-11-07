import { $api } from '@/utils/api'

const domainService = {

  getDomains(params = {}) {
    return $api('/domains', { params })
  },
  
 
  getDomain(id: any) {
    return $api(`/domains/${id}`)
  },

  createDomain(data: any) {
    return $api('/domains', {
      method: 'POST',
      body: data
    })
  },
  

  updateDomain(id: any, data: any) {
    if (data instanceof FormData) {
      data.append('_method', 'PUT') 
      return $api(`/domains/${id}`, {
        method: 'POST',
        body: data
      })
    }
    return $api(`/domains/${id}`, {
      method: 'PUT',
      body: data
    })
  },
  

  deleteDomain(id: any) {
    return $api(`/domains/${id}`, {
      method: 'DELETE'
    })
  },
  
 
  toggleDomainStatus(id: any, statusData: any) {
    return $api(`/domains/${id}/toggle-active`, {
      method: 'POST',
      body: statusData
    })
  },
  
 
  uploadIcon(id: any, formData: FormData) {
    return $api(`/domains/${id}/icon`, {
      method: 'POST',
      body: formData
    })
  },
  
 
  removeIcon(id: any) {
    return $api(`/domains/${id}/icon`, {
      method: 'DELETE'
    })
  },
  
  
  async getCsrfCookie() {
    await $api('/sanctum/csrf-cookie')
  }
}

export default domainService
