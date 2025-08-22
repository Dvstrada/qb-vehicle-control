// Vehicle control NUI script
// Handles UI interactions for engine/doors/lights menu

window.addEventListener('load', function() {
  const menu = document.getElementById('vehicleMenu');
  const lightsButton = document.getElementById('btnLights');
  const doorButtons = document.querySelectorAll('#vehicleMenu button[data-door]');
  const closeButton = document.getElementById('btnClose');

  function openMenu() {
    menu.style.display = 'flex';
  }

  function closeMenu() {
    menu.style.display = 'none';
  }

  // Listen for messages from client script
  window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) return;
    if (data.action === 'open') {
      openMenu();
    } else if (data.action === 'close') {
      closeMenu();
    }
  });

  // Toggle vehicle lights
  lightsButton.addEventListener('click', () => {
    fetch('https://qb-vehicle-control/toggleLights', { method: 'POST' });
  });

  // Toggle doors, hood, trunk
  doorButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const door = parseInt(button.getAttribute('data-door'));
      fetch('https://qb-vehicle-control/toggleDoor', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ door: door })
      });
    });
  });

  // Close UI
  closeButton.addEventListener('click', () => {
    closeMenu();
    fetch('https://qb-vehicle-control/close', { method: 'POST' });
  });
});
