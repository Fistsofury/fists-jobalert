window.addEventListener('message', function(event) {
    if (event.data.type === 'openAlerts') {
        const app = document.getElementById('app');
        app.innerHTML = '<div class="alerts">' + event.data.alerts.map(function(alert) {
            return `<div class="alert-item">
                        <h3>${alert.job.toUpperCase()} Alert</h3>
                        <button class="assign-btn" onclick="assignAlert(${alert.id}, ${alert.coords.x}, ${alert.coords.y})">Assign</button>
                        <button class="cancel-btn" onclick="cancelAlert(${alert.id})">Cancel</button>
                    </div>`;
        }).join('') + '</div>';
    }
});

function assignAlert(alertId, x, y) {
    fetch(`https://${GetParentResourceName()}/assignAlert`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
        alertId: alertId,
        coords: { x, y },
      }),
    })
    .then(() => {
        console.log('Assigned to alert successfully');
    })
    .catch((error) => {
        console.error('Error assigning to alert:', error);
    });
}

function cancelAlert(alertId) {
    fetch(`https://${GetParentResourceName()}/cancelAlert`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
        alertId: alertId,
      }),
    })
    .then(() => {
        console.log('Cancelled alert successfully');
    })
    .catch((error) => {
        console.error('Error cancelling alert:', error);
    });
}
