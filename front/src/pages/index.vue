<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import userService from '@/services/userService'
import clientService from '@/services/clientService'
import categoryService from '@/services/categoryService'
import { VSkeletonLoader } from 'vuetify/components'

const router = useRouter()

// State for dashboard data
const users = ref([])
const clients = ref([])
const categories = ref([])
const isLoading = ref(true)
const recentClients = ref([])

// Stats cards data - use tabler icons instead of mdi
const stats = ref([
  { 
    title: 'Total Users', 
    count: 0, 
    color: 'primary', 
    icon: 'tabler-users',
    route: '/apps/user/list'
  },
  { 
    title: 'Total Clients', 
    count: 0, 
    color: 'success', 
    icon: 'tabler-building',
    route: '/apps/client/list'
  },
  { 
    title: 'Categories', 
    count: 0, 
    color: 'info', 
    icon: 'tabler-tag',
    route: '/apps/categories/list'
  },
])

// Fetch all dashboard data
const fetchDashboardData = async () => {
  isLoading.value = true
  try {
    const [usersResult, clientsResult, categoriesResult] = await Promise.allSettled([
      userService.getUsers(),
      clientService.getClients(),
      categoryService.getCategories()
    ])
    
    if (usersResult.status === 'fulfilled') {
      const usersResponse = usersResult.value
      if (Array.isArray(usersResponse)) {
        users.value = usersResponse
      } else if (usersResponse && typeof usersResponse === 'object') {
        users.value = usersResponse.data || []
      } else {
        users.value = []
      }
      stats.value[0].count = users.value.length
    }
    
    if (clientsResult.status === 'fulfilled') {
      const clientsResponse = clientsResult.value
      if (Array.isArray(clientsResponse)) {
        clients.value = clientsResponse
      } else if (clientsResponse && typeof clientsResponse === 'object') {
        clients.value = clientsResponse.data || []
      } else {
        clients.value = []
      }
      stats.value[1].count = clients.value.length
      
      recentClients.value = [...clients.value]
        .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
        .slice(0, 5)
    }
    
    if (categoriesResult.status === 'fulfilled') {
      const categoriesResponse = categoriesResult.value
      if (Array.isArray(categoriesResponse)) {
        categories.value = categoriesResponse
      } else if (categoriesResponse && typeof categoriesResponse === 'object') {
        categories.value = categoriesResponse.data || []
      } else {
        categories.value = []
      }
      stats.value[2].count = categories.value.length
    }
    
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  } finally {
    isLoading.value = false
  }
}

// Navigation helpers
const navigateTo = (route) => {
  router.push(route)
}

onMounted(() => {
  fetchDashboardData()
})
</script>

<template>
  <div>
    <!-- Stats Cards Row -->
    <VRow>
      <VCol
        v-for="(stat, index) in stats"
        :key="index"
        cols="12"
        sm="4"
      >
        <VCard
          :color="stat.color"
          variant="tonal"
          class="h-100"
        >
          <VCardItem>
            <template #prepend>
              <VAvatar
                :color="stat.color"
                size="48"
                rounded
                class="me-3"
              >
                <VIcon
                  :icon="stat.icon"
                  size="32"
                />
              </VAvatar>
            </template>
            
            <VCardTitle>
              {{ stat.title }}
            </VCardTitle>
            
            <template #append>
              <div class="mt-n2">
                <h3 class="text-h3 mb-0">
                  <VSkeletonLoader
                    v-if="isLoading"
                    type="text"
                    width="50px"
                  />
                  <span v-else>{{ stat.count }}</span>
                </h3>
              </div>
            </template>
          </VCardItem>
          
          <VCardActions>
            <VBtn
              variant="tonal"
              :color="stat.color"
              @click="navigateTo(stat.route)"
            >
              View Details
            </VBtn>
          </VCardActions>
        </VCard>
      </VCol>
    </VRow>
    
    <!-- Recent Clients Section - now takes full width -->
    <VRow class="mt-3">
      <VCol cols="12">
        <VCard title="Recent Clients">
          <VCardText>
            <VSkeletonLoader
              v-if="isLoading"
              type="table-heading, table-row-divider, table-row, table-row-divider, table-row"
            />
            
            <div v-else>
              <VList v-if="recentClients.length > 0">
                <VListItem
                  v-for="client in recentClients"
                  :key="client.id"
                  :title="client.raison_sociale"
                  :subtitle="client.email || 'No email'"
                  lines="two"
                  @click="navigateTo(`/apps/client/view/${client.id}`)"
                >
                  <template #prepend>
                    <VAvatar color="primary" variant="tonal">
                      {{ client.raison_sociale.charAt(0).toUpperCase() }}
                    </VAvatar>
                  </template>
                  
                  <template #append>
                    <VChip
                      v-if="client.categories_id"
                      size="small"
                      color="primary"
                      variant="tonal"
                      class="ms-2"
                    >
                      {{ categories.find(c => c.id == client.categories_id)?.label || 'Uncategorized' }}
                    </VChip>
                  </template>
                </VListItem>
              </VList>
              
              <div v-else class="text-center pa-3">
                <VIcon icon="tabler-building-off" size="48" class="mb-2" color="grey" />
                <p>No clients found. Add your first client!</p>
                <VBtn color="primary" @click="navigateTo('/apps/client/list')">
                  Add New Client
                </VBtn>
              </div>
            </div>
          </VCardText>
          
          <VCardActions>
            <VSpacer />
            <VBtn
              color="primary"
              variant="text"
              @click="navigateTo('/apps/client/list')"
            >
              View All Clients
            </VBtn>
          </VCardActions>
        </VCard>
      </VCol>
    </VRow>
    
    <!-- Quick Actions -->
    <VRow class="mt-3">
      <VCol cols="12">
        <VCard title="Quick Actions">
          <VCardText>
            <div class="d-flex flex-wrap gap-4">
              <VBtn
                prepend-icon="tabler-user-plus"
                color="primary"
                @click="navigateTo('/apps/user/list')"
              >
                New User
              </VBtn>
              
              <VBtn
                prepend-icon="tabler-building-plus"
                color="success"
                @click="navigateTo('/apps/client/list')"
              >
                New Client
              </VBtn>
              
              <VBtn
                prepend-icon="tabler-tag-plus"
                color="info"
                @click="navigateTo('/apps/categories/list')"
              >
                New Category
              </VBtn>
              
            
            </div>
          </VCardText>
        </VCard>
      </VCol>
    </VRow>
  </div>
</template>

<style scoped>
.v-list-item {
  cursor: pointer;
}
</style>
