export default [
  {
    title: 'Home',
    to: { name: 'root' },
    icon: { icon: 'tabler-smart-home' },
  },
    {
    title: 'Clients',
    to: { name: 'apps-client-list' },
    icon: { icon: 'tabler-users' },
  },
 {
    title: 'Rréférentiel',
    icon: { icon: 'tabler-book' },
    children: [
      {
        title: 'Categories',
        to: { name: 'apps-categories-list' },
        icon: { icon: 'tabler-category' },
      },
      {
        title: 'Domain d\'activité',
        to: { name: 'apps-domain-list' },
        icon: { icon: 'tabler-sitemap' },
      },
      
      {
        title: 'User',
        to: { name: 'apps-user-list' },
        icon: { icon: 'tabler-user' },
      },
    ],
  },

]
