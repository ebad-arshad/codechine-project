const API_URL = '/api/todos';

async function fetchTodos() {
    const res = await fetch(API_URL);
    const data = await res.json();
    const list = document.getElementById('todoList');
    list.innerHTML = data.map(t => `<li>${t.task}</li>`).join('');
}

async function addTodo() {
    const input = document.getElementById('todoInput');
    await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ task: input.value })
    });
    input.value = '';
    fetchTodos();
}

fetchTodos();