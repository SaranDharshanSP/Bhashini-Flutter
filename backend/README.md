# Flask OpenAI Q&A Service

A simple Flask API that answers questions using OpenAI's GPT model, providing responses in 3-4 sentences.

## Setup

1. Install dependencies:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

2. Set up environment variables:
   \`\`\`bash
   cp .env.example .env
   # Edit .env and add your OpenAI API key
   \`\`\`

3. Run the application:
   \`\`\`bash
   python app.py
   \`\`\`

## API Endpoints

### POST /answer
Answers a question in 3-4 sentences.

**Request Body:**
\`\`\`json
{
  "question": "What is machine learning?"
}
\`\`\`

**Response:**
\`\`\`json
{
  "question": "What is machine learning?",
  "answer": "Machine learning is a subset of artificial intelligence that enables computers to learn and make decisions from data without being explicitly programmed. It uses algorithms to identify patterns in data and make predictions or classifications based on those patterns. Common applications include recommendation systems, image recognition, and natural language processing. The technology powers many modern applications from search engines to autonomous vehicles.",
  "status": "success"
}
\`\`\`

### GET /health
Health check endpoint.

## Usage Example

\`\`\`bash
curl -X POST http://localhost:5000/answer \
  -H "Content-Type: application/json" \
  -d '{"question": "What is climate change?"}'
\`\`\`

## Testing

Run the test script to try multiple questions:
\`\`\`bash
python test_endpoint.py
