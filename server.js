const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from public directory
app.use(express.static('public'));

// API endpoint
app.get('/api/info', (req, res) => {
  res.json({
    message: 'Hello SLIIT!',
    timestamp: new Date().toISOString(),
    hostname: require('os').hostname(),
    version: '1.0.0'
  });
});

// Health check endpoint for Kubernetes
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Serve index.html for root path
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Hello SLIIT app running on port ${PORT}`);
  console.log(`📍 Visit: http://localhost:${PORT}`);
});
