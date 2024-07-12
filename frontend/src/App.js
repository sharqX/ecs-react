import React, { useState, useEffect } from 'react';
import axios from 'axios';

const HelloComponent = () => {
  const [item, setItem] = useState('');

  useEffect(() => {
    // Fetch the data from the API
    const fetchData = async () => {
      try {
        const response = await axios.get('http://13.235.79.153:1337/api/messages');
        // Extract the "Hello" value from the response
        const helloValue = response.data.data[0].attributes.item;
        setItem(helloValue);
      } catch (error) {
        console.error('Error fetching the data', error);
      }
    };

    fetchData();
  }, []);

  return (
    <div>
      {item}
    </div>
  );
};

export default HelloComponent;
