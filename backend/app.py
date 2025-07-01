from flask import Flask, request, jsonify
from openai import OpenAI
import os
from dotenv import load_dotenv
from flask_cors import CORS
# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes
# Initialize OpenAI client
client = OpenAI(
    api_key='your-api-key'
)
@app.route('/answer', methods=['POST'])
def answer_question():
    try:
        # Get the input from request
        data = request.get_json()
        
        if not data or 'question' not in data:
            return jsonify({'error': 'Please provide a question in the request body'}), 400
        
        question = data['question']
        
        if not question.strip():
            return jsonify({'error': 'Question cannot be empty'}), 400
        
        # Create the prompt with instruction to limit response
        prompt = f"""Please answer the following question in exactly 3-4 sentences. Be concise and informative.

Question: {question}

Answer:"""
        
        # Make API call to OpenAI using the new client syntax
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "system", 
                    "content": "You are a helpful assistant that provides concise answers in exactly 3-4 sentences."
                },
                {
                    "role": "user", 
                    "content": prompt
                }
            ],
            max_tokens=150,
            temperature=0.7
        )
        
        # Extract the answer
        answer = response.choices[0].message.content.strip()
        
        return jsonify({
            'question': question,
            'answer': answer,
            'status': 'success'
        })
        
    except Exception as e:
        # Handle different types of OpenAI errors
        error_message = str(e)
        status_code = 500
        
        if "authentication" in error_message.lower() or "api key" in error_message.lower():
            status_code = 401
            error_message = "Invalid OpenAI API key"
        elif "rate limit" in error_message.lower():
            status_code = 429
            error_message = "OpenAI API rate limit exceeded"
        elif "insufficient_quota" in error_message.lower():
            status_code = 402
            error_message = "OpenAI API quota exceeded"
        
        return jsonify({'error': error_message}), status_code

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'message': 'Flask OpenAI Q&A service is running'})

@app.route('/test', methods=['GET'])
def test_openai():
    """Test endpoint to verify OpenAI connection"""
    try:
        # Simple test call
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",  # Using cheaper model for testing
            messages=[{"role": "user", "content": "Say 'API connection successful'"}],
            max_tokens=10
        )
        return jsonify({
            'status': 'success',
            'message': 'OpenAI API connection is working',
            'test_response': response.choices[0].message.content.strip()
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': f'OpenAI API connection failed: {str(e)}'
        }), 500

if __name__ == '__main__':
    # Check if API key is set
    api_key = os.getenv('OPENAI_API_KEY')
    if not api_key:
        print("Warning: OPENAI_API_KEY environment variable not set")
        print("Please set your OpenAI API key in the .env file or environment variables")
    else:
        print("OpenAI API key loaded successfully")
    
    print("Starting Flask server on http://0.0.0.0:5000")
    print("Available endpoints:")
    print("  POST /answer - Answer questions")
    print("  GET  /health - Health check")
    print("  GET  /test   - Test OpenAI connection")
    
    app.run(debug=True, host='0.0.0.0', port=5000)