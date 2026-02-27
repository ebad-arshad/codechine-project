const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors({ origin: process.env.FRONTEND_URL || '*' }));
app.use(express.json());

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI;

mongoose.connect(MONGODB_URI)
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log('MongoDB connection error:', err));

const TodoSchema = new mongoose.Schema({ task: { type: String, required: true, trim: true, maxlength: 255 } });
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
  try {
    const todos = await Todo.find().sort({ _id: -1 }); // Sorting to show newest first
    res.json(todos);
  } catch (err) {
    console.error('Error fetching tasks:', err);
    res.status(500).json({ error: 'Server error parsing tasks' });
  }
});

// Add a task
app.post('/api/todos', async (req, res) => {
  try {
    const { task } = req.body;
    if (!task || typeof task !== 'string' || task.trim() === '') {
      return res.status(400).json({ error: 'Valid task text is required' });
    }
    const sanitizedTask = task.trim().substring(0, 255);
    const newTodo = new Todo({ task: sanitizedTask });
    await newTodo.save();
    res.status(201).json(newTodo);
  } catch (err) {
    console.error('Error saving task:', err);
    res.status(500).json({ error: 'Server error saving task' });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
  console.log('Created by: Muhammad Ebad Arshad')
});