window.addEventListener('message', function (event) {
    if (event.data.type === 'openAlerts') {
        showMenu(event.data.alerts, event.data.jobType);
    }
});

function showMenu(alerts, jobType) {
    document.body.style.display = 'block'; 
    const app = document.getElementById('app');
    app.innerHTML = '<div class="alerts">' + alerts.map(function (alert) {
        return `<div class="alert-item">
                    <h3>${jobType.toUpperCase()} Alert</h3>
                    <button class="assign-btn" onclick="assignAlert(${alert.id}, ${alert.coords.x}, ${alert.coords.y})">Assign</button>
                    <button class="cancel-btn" onclick="cancelAlert(${alert.id})">Cancel</button>
                </div>`;
    }).join('') + '</div>';
}

function assignAlert(alertId, x, y) {
    fetch(`https://${GetParentResourceName()}/assignAlert`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            alertId: alertId,
            coords: { x, y },
        })
    }).then(response => response.json())
    .then(data => {
        console.log('Assigned to alert successfully', data);
        closeMenu();
    })
    .catch(error => console.error('Error assigning to alert:', error));
}

function cancelAlert(alertId) {
    fetch(`https://${GetParentResourceName()}/cancelAlert`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            alertId: alertId,
        })
    }).then(response => response.json())
    .then(data => {
        console.log('Cancelled alert successfully', data);
        closeMenu();
    })
    .catch(error => console.error('Error cancelling alert:', error));
}

function closeMenu() {
    document.body.style.display = 'none'; 
    const app = document.getElementById('app');
    app.innerHTML = '';
}
