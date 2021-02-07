import axios from 'axios';

const Api = axios.create({
  baseURL: process.env.VUE_APP_FC2_API
});

// Add a request interceptor
Api.interceptors.request.use(
  async function(config) {
    let accessToken = localStorage.getItem('accessToken');
    console.log('@accessToken=====>', accessToken);
    config.headers = {
      Authorization: `Bearer ${accessToken}`,
      Accept: 'application/json'
    };
    return config;
  },
  function(error) {
    // Do something with request error
    return Promise.reject(error);
  }
);

// Add a response interceptor
Api.interceptors.response.use(
  function(response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response;
  },
  async function(error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    console.log('@response.error====>', error.config);
    console.log('@response.error.status====>', error.response.status);
    const originalRequest = error.config;
    const errorStatus = error.response.status;
    const refreshToken = localStorage.getItem('refreshToken');

    if (errorStatus === 401 && !originalRequest.retry && refreshToken) {
      console.log('401 #####################################');
      originalRequest.retry = true;
      console.log('토큰이 이상한 오류일 경우');
      return fetchAccessToken(refreshToken, originalRequest);
    } else {
      console.log('Else ####################################');
      if (errorStatus === 404) {
        console.error('404 error');
      }
    }
    return Promise.reject(error);
  }
);

async function fetchAccessToken(refreshToken, originalRequest) {
  try {
    const response = await Api.post('/api/auth/token/refresh/', {
      refreshToken: refreshToken
    });
    const newAccessToken = response.data.accessToken;
    const newRefreshToken = response.data.refreshToken;
    localStorage.setItem('accessToken', newAccessToken);
    localStorage.setItem('refreshToken', newRefreshToken);
    originalRequest.headers['Authorization'] = 'Bearer ' + newAccessToken;
    return await axios(originalRequest);
  } catch (error) {
    originalRequest.retry = false;
    console.log(error);
  }
}

export default Api;
