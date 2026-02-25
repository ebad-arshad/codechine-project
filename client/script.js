const API_URL = '/api/todos';

async function fetchTodos() {
    try {
        const res = await fetch(API_URL);
        if (!res.ok) throw new Error('Failed to fetch todos');
        const data = await res.json();
        const list = document.getElementById('todoList');
        list.innerHTML = '';
        data.forEach(t => {
            const li = document.createElement('li');
            li.textContent = t.task;
            list.appendChild(li);
        });
    } catch (error) {
        console.error('Error fetching todos:', error);
    }
}

async function addTodo() {
    const input = document.getElementById('todoInput');
    const task = input.value.trim();
    if (!task) return;

    try {
        const res = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ task })
        });
        if (!res.ok) throw new Error('Failed to add todo');
        input.value = '';
        fetchTodos();
    } catch (error) {
        console.error('Error adding todo:', error);
    }
}

fetchTodos();