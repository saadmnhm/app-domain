import { $api } from '@/utils/api'

const domainService = {
  /**
   * Get domains (with optional filters)
   */
  getDomains(params = {}) {
    return $api('/domains', { params })
  },
  
  /**
   * Get single domain
   */
  getDomain(id: any) {
    return $api(`/domains/${id}`)
  },
  
  /**
   * Create domain
   */
  createDomain(data: any) {
    return $api('/domains', {
      method: 'POST',
      body: data
    })
  },
  
  /**
   * Update domain
   */
  updateDomain(id: any, data: any) {
    if (data instanceof FormData) {
      data.append('_method', 'PUT') // Laravel FormData PUT workaround
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
  
  /**
   * Delete domain
   */
  deleteDomain(id: any) {
    return $api(`/domains/${id}`, {
      method: 'DELETE'
    })
  },
  
  /**
   * Toggle domain status
   */
  toggleDomainStatus(id: any, statusData: any) {
    return $api(`/domains/${id}/toggle-active`, {
      method: 'POST',
      body: statusData
    })
  },
  
  /**
   * Upload domain icon
   */
  uploadIcon(id: any, formData: FormData) {
    return $api(`/domains/${id}/icon`, {
      method: 'POST',
      body: formData
    })
  },
  
  /**
   * Remove domain icon
   */
  removeIcon(id: any) {
    return $api(`/domains/${id}/icon`, {
      method: 'DELETE'
    })
  },
  
  /**
   * Get CSRF cookie
   */
  async getCsrfCookie() {
    await $api('/sanctum/csrf-cookie')
  }
}

export default domainService
