<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue';
import userService from '@/services/userService';
import AddNewUserDrawer from '@/views/apps/user/list/AddNewUserDrawer.vue';
import type { UserProperties } from '@db/apps/users/types';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/authStore' 

const router = useRouter();
const authStore = useAuthStore()

const users = ref<UserProperties[]>([]);
const totalUsers = ref(0);
const isLoading = ref(true);
const error = ref('');

const searchQuery = ref('');
const selectedRole = ref('');
const page = ref(1);
const itemsPerPage = ref(10);
const sortBy = ref('fullName');
const sortDesc = ref(false);

const isAddNewUserDrawerVisible = ref(false);

const currentUserId = computed(() => authStore.user?.id)

const resolveUserRoleVariant = (role: string) => {
  const roleLowerCase = role?.toLowerCase() || '';

  if (roleLowerCase === 'manager')
    return { color: 'info', icon: 'tabler-pencil' };
  if (roleLowerCase === 'admin')
    return { color: 'error', icon: 'tabler-device-laptop' };
    
  return { color: 'primary', icon: 'tabler-user' };
};


const avatarText = (firstName: string, lastName: string) => {
  const name = `${firstName} ${lastName}`;
  if (!name) return '';
  return name.split(' ').map(word => word.charAt(0).toUpperCase()).join('');
};

const fetchUsers = async () => {
  isLoading.value = true;
  error.value = '';
  
  try {
    const params = {
      page: page.value,
      limit: itemsPerPage.value,
      search: searchQuery.value || undefined,
      role: selectedRole.value || undefined,
      sortBy: sortBy.value,
      sortOrder: sortDesc.value ? 'desc' : 'asc',
    };
    
    const response = await userService.getUsers(params);
    
    if (response) {
      
      let apiUsers = [];
      
      if (Array.isArray(response)) {
        apiUsers = response;
      } else if (Array.isArray(response.users)) {
        apiUsers = response.users;
      } else if (Array.isArray(response.data)) {
        apiUsers = response.data;
      }
      
      users.value = apiUsers.map(user => ({
        id: user.id,
        firstName: user.first_name || user.firstName || '',
        lastName: user.last_name || user.lastName || '',
        email: user.email || '',
        role: user.role || 'user',
        is_active: user.is_active,
        avatar: user.avatar || null,
        currentPlan: user.currentPlan || user.current_plan || user.plan || 'basic',
        billing: user.billing || 'monthly',
        contact: user.contact || user.phone || '',
      }));
      
      totalUsers.value = response.total || 
      (response.meta ? response.meta.total : null) || 
      users.value.length;
      
      
      
      if (users.value.length === 0) {
      }
    } else {
      console.error('Invalid response format', response);
      error.value = 'Invalid response format from server';
      users.value = [];
    }
  } catch (err) {
    console.error('Error fetching users:', err);
    error.value = 'Failed to load users. Please try again.';
    users.value = [];
  } finally {
    isLoading.value = false;
  }
};


const addNewUser = (userData: UserProperties) => {
  fetchUsers(); 
};

watch([page, itemsPerPage,], () => {
  fetchUsers();
}, { deep: true });

onMounted(() => {
  fetchUsers();
});

const viewUser = (id: number) => {
  router.push({ name: 'apps-user-view-id', params: { id } });
};

const showEmptyState = computed(() => {
  return !isLoading.value && users.value.length === 0;
});

const filteredUsers = computed(() => {
  return users.value.filter(user => user.id !== currentUserId.value)
})
</script>

<template>
  <section>
    <VCard>
      <VCardText class="d-flex flex-wrap gap-4">
        <div class="d-flex gap-2 align-center">
          <p class="text-body-1 mb-0">Show</p>
          <AppSelect
            :model-value="itemsPerPage"
            :items="[
              { value: 10, title: '10' },
              { value: 25, title: '25' },
              { value: 50, title: '50' },
              { value: 100, title: '100' },
              { value: -1, title: 'All' },
            ]"
            density="compact"
            style="inline-size: 5.5rem;"
            @update:model-value="itemsPerPage = parseInt($event, 10)"
          />
        </div>

        <VSpacer />

        <div class="d-flex align-center flex-wrap gap-4">

          <!-- 👉 Add user button -->
          <VBtn color="primary" prepend-icon="tabler-plus" @click="isAddNewUserDrawerVisible = true">
             Add User
          </VBtn>
        </div>
      </VCardText>

      <VDivider />
      
      <!-- Loading state -->
      <VProgressLinear
        v-if="isLoading"
        indeterminate
        color="primary"
      />

      <!-- Error state -->
      <VAlert
        v-if="error"
        type="error"
        variant="tonal"
        class="ma-4"
        closable
      >
        {{ error }}
      </VAlert>

      <!-- Empty state -->
      <VAlert
        v-if="showEmptyState"
        type="info"
        variant="tonal"
        class="ma-4"
      >
        No users found. Try changing your search criteria or add a new user.
      </VAlert>

      <!-- User cards -->
      <VCardText v-if="!isLoading && users.length > 0">
        <VRow>
          <VCol
            v-for="user in filteredUsers"
            :key="user.id"
            cols="12"
            sm="6"
            md="4"
            lg="4"
            xl="3"
          >
            <VCard class="user-card h-100" :elevation="3">
              <!-- User Header -->
              <VCardItem>
                <template #prepend>
                  <VAvatar
                    size="45"
                    :variant="!user.avatar ? 'tonal' : undefined"
                    :color="!user.avatar ? resolveUserRoleVariant(user.role).color : undefined"
                  >
                    <VImg
                      v-if="user.avatar"
                      :src="`http://127.0.0.1:8000${user.avatar}`"
                    />
                    <span v-else>{{ avatarText(user.firstName, user.lastName) }}</span>
                  </VAvatar>
                </template>
                <VCardTitle>
                  <RouterLink
                    :to="{ name: 'apps-user-view-id', params: { id: user.id } }"
                    class="font-weight-medium text-link text-truncate"
                  >
                    {{ user.firstName }} {{ user.lastName }}
                  </RouterLink>
                </VCardTitle>
                <VCardSubtitle class="text-truncate">
                  {{ user.email }}
                </VCardSubtitle>

              </VCardItem>

              <VDivider />

              <!-- User Details -->
              <VCardText>
                <div class="d-flex justify-space-between align-center mb-2">
                  <div class="d-flex align-center">
                    <VIcon
                      :size="18"
                      :icon="resolveUserRoleVariant(user.role).icon"
                      :color="resolveUserRoleVariant(user.role).color"
                      class="me-1"
                    />
                    <span class="">{{ user.role }}</span>
                  </div>
                  <VChip v-if="user.is_active > 0"
                    size="small"
                    label
                    color="success"
                    class=""
                  >
                    Active
                  </VChip>
                  <VChip v-else
                    size="small"
                    label
                    color="error"
                    class=""
                  >
                    Inactive
                  </VChip>
                </div>

                <div class="d-flex align-center mt-3">
                  <VIcon icon="tabler-mail" size="18" class="me-2" />
                  <span class="text-body-2">Email:</span>
                  <span class="ms-1 text-body-2 text-high-emphasis ">
                    {{ user.email}}
                  </span>
                </div>

              </VCardText>

              <!-- Action Buttons -->
              <VCardActions>
                <VBtn 
                  variant="tonal" 
                  size="small"
                  @click="viewUser(user.id)"
                >
                  View
                </VBtn>
              </VCardActions>
            </VCard>
          </VCol>
        </VRow>

        <!-- Pagination -->
        <div class="d-flex justify-center mt-6" v-if="totalUsers > itemsPerPage">
          <VPagination
            v-model="page"
            :length="Math.ceil(totalUsers / itemsPerPage)"
            :total-visible="5"
          />
        </div>
      </VCardText>
    </VCard>

    <!-- 👉 Add New User -->
    <AddNewUserDrawer
      v-model:is-drawer-open="isAddNewUserDrawerVisible"
      @user-data="addNewUser"
    />
  </section>
</template>

<style lang="scss">


.user-card {
  transition: transform 0.2s, box-shadow 0.2s;
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 7px 15px rgba(var(--v-shadow-key-umbra-color), 0.15) !important;
  }
}

.text-link {
  color: rgb(var(--v-theme-primary));
  text-decoration: none;
  &:hover {
    text-decoration: underline;
  }
}

// Ensure truncation works properly
.text-truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}
</style>
