module ApplicationHelper
  def active_nav(controller, action)
    {
      'pages' => {
        'show' => 'home',
        'about' => 'about',
        'contact' => 'contact',
        'itinerary' => 'itinerary',
        'activities' => 'activities'
      },
      'reservations' => {
        'new' => 'rsvp',
        'edit' => 'rsvp'
      },
      'sessions' => {
        'new' => 'login'
      }
    }[controller][action]
  end
end
