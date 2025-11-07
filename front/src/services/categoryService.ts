import { $api } from '@/utils/api'

const categoryService = {
  /**
   * Get categories with optional filters and pagination
   */
  getCategories(params = {}) {
    return $api('/categories', { params })
  },

  /**
   * Get single category by ID
   */
  getCategory(id: number) {
    return $api(`/categories/${id}`)
  },

  /**
   * Create a new category
   */
  createCategory(categoryData: any) {
    return $api('/categories', {
      method: 'POST',
      body: categoryData
    })
  },

  /**
   * Update existing category
   */
  updateCategory(id: number, categoryData: any) {
    return $api(`/categories/${id}`, {
      method: 'PUT',
      body: categoryData
    })
  },

  /**
   * Delete a category
   */
  deleteCategory(id: number) {
    return $api(`/categories/${id}`, {
      method: 'DELETE'
    })
  },

  /**
   * Toggle category status (active/inactive)
   */
  toggleCategoryStatus(categoryId: number, statusData: any) {
    return $api(`/categories/${categoryId}/toggle-active`, {
      method: 'POST',
      body: statusData
    })
  },

  /**
   * Upload category icon
   */
  uploadIcon(categoryId: number, formData: FormData) {
    return $api(`/categories/${categoryId}/icon`, {
      method: 'POST',
      body: formData
    })
  },

  /**
   * Remove category icon
   */
  removeIcon(categoryId: number) {
    return $api(`/categories/${categoryId}/icon`, {
      method: 'DELETE'
    })
  },

  /**
   *  CSRF cookie 
   */
  async getCsrfCookie() {
    await $api('/sanctum/csrf-cookie')
  },
}

export default categoryService
