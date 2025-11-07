import { $api } from '@/utils/api'

const userService = {

  getUsers(params = {}) {
    return $api(`/users`, { params });
  },

  getUser(id: number) {
    return $api(`/users/${id}`);
  },

 
  createUser(userData: any) {
    if (userData instanceof FormData) {
      return $api(`/users`, userData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
    } else {
      return $api(`/users`, userData);
    }
  },

 
  updateUser(id: number, userData: any) {
    return $api(`/users/${id}`, userData);
  },


  deleteUser(id: number) {
    return $api(`/users/${id}`, {
      method: 'DELETE'
    });
  },

 
  updateUserPassword(userId: number, passwordData: any) {
    return $api(`/users/${userId}/password`, passwordData);
  },

  toggleUserStatus(userId: number, statusData: any) {
    return $api(`/users/${userId}/toggle-active`, statusData);
  },
  
  uploadAvatar(userId: number, formData: any) {
    return $api(`/users/${userId}/avatar`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
  },

 
  removeAvatar(userId: number) {
    return $api(`/users/${userId}/avatar`, {
      method: 'DELETE'
    });
  },
 
  getCurrentUser() {
    return $api(`/user`);
  },

 
  async getCsrfCookie() {
    await $api('/sanctum/csrf-cookie');
  },
};

export default userService;
