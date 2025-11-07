import { $api } from '@/utils/api'

const categoryService = {

  getCategories(params = {}) {
    return $api('/categories', { params })
  },


  getCategory(id: number) {
    return $api(`/categories/${id}`)
  },


  createCategory(categoryData: any) {
    return $api('/categories', {
      method: 'POST',
      body: categoryData
    })
  },


  updateCategory(id: number, categoryData: any) {
    return $api(`/categories/${id}`, {
      method: 'PUT',
      body: categoryData
    })
  },


  deleteCategory(id: number) {
    return $api(`/categories/${id}`, {
      method: 'DELETE'
    })
  },


  toggleCategoryStatus(categoryId: number, statusData: any) {
    return $api(`/categories/${categoryId}/toggle-active`, {
      method: 'POST',
      body: statusData
    })
  },

 
  uploadIcon(categoryId: number, formData: FormData) {
    return $api(`/categories/${categoryId}/icon`, {
      method: 'POST',
      body: formData
    })
  },

 
  removeIcon(categoryId: number) {
    return $api(`/categories/${categoryId}/icon`, {
      method: 'DELETE'
    })
  },


  async getCsrfCookie() {
    await $api('/sanctum/csrf-cookie')
  },
}

export default categoryService
