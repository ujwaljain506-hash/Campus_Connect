importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAygqZbrM9A7LKbEcRAgO__qcGhcyT5kjk",
  authDomain: "campus-connect-a4113.firebaseapp.com",
  projectId: "campus-connect-a4113",
  storageBucket: "campus-connect-a4113.firebasestorage.app",
  messagingSenderId: "12844574121",
  appId: "1:12844574121:web:4fde735b7dc776d40a10b8"
});

const messaging = firebase.messaging();
