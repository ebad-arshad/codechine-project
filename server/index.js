const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/todo-db';

mongoose.connect(MONGODB_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log('MongoDB connection error:', err));

const TodoSchema = new mongoose.Schema({ task: String });
const Todo = mongoose.model('Todo', TodoSchema);

// Checks if the Application process is running
app.get('/api/health', (req, res) => {
    res.status(200).json({
        status: 'UP',
        message: 'Application is running'
    });
});

// Checks the actual connection state to MongoDB
app.get('/api/db', (req, res) => {
    const state = mongoose.connection.readyState;
    // 0: disconnected, 1: connected, 2: connecting, 3: disconnecting
    const states = {
        0: 'Disconnected',
        1: 'Connected',
        2: 'Connecting',
        3: 'Disconnecting'
    };
    
    if (state === 1) {
        res.status(200).json({ status: 'UP', database: states[state] });
    } else {
        res.status(503).json({ status: 'DOWN', database: states[state] });
    }
});

// Get all tasks
app.get('/api/todos', async (req, res) => {
  const todos = await Todo.find();
  res.json(todos);
});

// Add a task
app.post('/api/todos', async (req, res) => {
  const newTodo = new Todo({ task: req.body.task });
  await newTodo.save();
  res.json(newTodo);
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));