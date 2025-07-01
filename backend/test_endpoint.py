import requests
import json

# Test the endpoint
def test_answer_endpoint():
    url = "http://localhost:5000/answer"
    
    # Test data
    test_questions = [
        "What is artificial intelligence?",
        "How does photosynthesis work?",
        "What are the benefits of renewable energy?",
        "Explain quantum computing in simple terms."
    ]
    
    for question in test_questions:
        payload = {"question": question}
        
        try:
            response = requests.post(url, json=payload)
            
            if response.status_code == 200:
                result = response.json()
                print(f"Question: {result['question']}")
                print(f"Answer: {result['answer']}")
                print("-" * 50)
            else:
                print(f"Error: {response.status_code} - {response.text}")
                
        except requests.exceptions.RequestException as e:
            print(f"Request failed: {e}")

if __name__ == "__main__":
    test_answer_endpoint()
