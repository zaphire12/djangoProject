async function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
};
async function prepare_fetch(url, method, data={}, http_method='POST') {
    const csrftoken = await getCookie('csrftoken');
    const requestOptions = {
        method: http_method,
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrftoken,
            'local-method': method,
        },
        body: JSON.stringify(data),
    };
    try {
        const response = await fetch(url, requestOptions);
        if (!response.ok) {
            throw new Error(`Ошибка HTTP: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('Произошла ошибка:', error);
        throw error;
    }
};