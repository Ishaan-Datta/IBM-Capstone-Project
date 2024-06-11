import React, { useState } from 'react';
import axios from 'axios';

const Form: React.FC<{ onDataReceive: (image: string, text: string) => void }> = ({ onDataReceive }) => {
  const [text, setText] = useState('');
  const [file, setFile] = useState<File | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const formData = new FormData();
    formData.append('text', text);
    if (file) {
      formData.append('file', file);
    }

    try {
      const response = await axios.post('http://api.example.com/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      const { image, responseText } = response.data;
      onDataReceive(image, responseText);
    } catch (error) {
      console.error('Error uploading data', error);
    }
  };

  return (
    <form onSubmit={handleSubmit} style={formStyle}>
      <div style={inputGroupStyle}>
        <label htmlFor="text">Text:</label>
        <input
          type="text"
          id="text"
          value={text}
          onChange={(e) => setText(e.target.value)}
          style={inputStyle}
        />
      </div>
      <div style={inputGroupStyle}>
        <label htmlFor="file">CSV File:</label>
        <input
          type="file"
          id="file"
          accept=".csv"
          onChange={(e) => setFile(e.target.files ? e.target.files[0] : null)}
          style={inputStyle}
        />
      </div>
      <button type="submit" style={buttonStyle}>Submit</button>
    </form>
  );
};

const formStyle: React.CSSProperties = {
  display: 'flex',
  flexDirection: 'column',
  gap: '1rem',
  maxWidth: '400px',
  margin: '0 auto',
};

const inputGroupStyle: React.CSSProperties = {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.5rem',
};

const inputStyle: React.CSSProperties = {
  padding: '0.5rem',
  borderRadius: '4px',
  border: '1px solid #ccc',
};

const buttonStyle: React.CSSProperties = {
  padding: '0.5rem 1rem',
  borderRadius: '4px',
  border: 'none',
  backgroundColor: '#007bff',
  color: 'white',
  cursor: 'pointer',
};

export default Form;