

WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
    while(1);
    WorkerScript.sendMessage({ 'reply': message })
}

