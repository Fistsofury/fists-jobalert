window.addEventListener('message', function (event) {
    if (event.data.type === 'openAlerts') {
        const app = document.getElementById('app');
        app.innerHTML = '<div class="alerts">' + event.data.alerts.map(function (alert) {
            return `<div class="alert-item">
                        <h3>${alert.job.toUpperCase()} Alert</h3>
                        <button class="assign-btn" onclick="assignAlert(${alert.id}, ${alert.coords.x}, ${alert.coords.y})">Assign</button>
                        <button class="cancel-btn" onclick="cancelAlert(${alert.id})">Cancel</button>
                    </div>`;
        }).join('') + '</div>';
    }
});

function assignAlert(alertId, x, y) {
    $.ajax({
        url: `https://${GetParentResourceName()}/assignAlert`,
        type: 'POST',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify({
            alertId: alertId,
            coords: { x, y },
        }),
        success: function (response) {
            console.log('Assigned to alert successfully', response);
        },
        error: function (error) {
            console.error('Error assigning to alert:', error);
        }
    });
}

function cancelAlert(alertId) {
    $.ajax({
        url: `https://${GetParentResourceName()}/cancelAlert`,
        type: 'POST',
        contentType: 'application/json; charset=UTF-8',
        data: JSON.stringify({
            alertId: alertId,
        }),
        success: function (response) {
            console.log('Cancelled alert successfully', response);
        },
        error: function (error) {
            console.error('Error cancelling alert:', error);
        }
    });
}
