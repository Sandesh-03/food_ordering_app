'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"flutter_bootstrap.js": "2063113c89b8db2a9f9c5c5e453dcbd5",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"main.dart.js": "733a53e8690911163890b08ab98121c8",
"version.json": "a651598f2a97204d253c3e1ffbdc0ed3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "9edbf9c3565292359c39879f6cc11c21",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "6011c107ed135779eb4c390c0d082e63",
"assets/assets/pancake.png": "da02b8b4cefe3318da8206c569f3fc4d",
"assets/assets/burger/grilled-beef-burger.png": "9cf853eed0310c416b48b2a95d84df9d",
"assets/assets/burger/beef-burger.png": "d999bbb49a153d80ccf49ec85ff6a246",
"assets/assets/burger/cheese-burger.png": "c19f532170012da448aba4cb326deb4b",
"assets/assets/burger/fried-chicken-burger.png": "bf4ff91682e221bbc7550f0cc30bbfbf",
"assets/assets/veg-salad.png": "d8f93e58d58de4cedf9ac74a2ba215ae",
"assets/assets/onboard_1.png": "0447a310aeeede85c5ee046103203e6d",
"assets/assets/thali/thali2.png": "8228ea93501cbe38660c8a8de51c9c33",
"assets/assets/thali/thali1.png": "416dfb1ee771519ea0a15c6735b8f163",
"assets/assets/thali/thali3.png": "e077baa2c4103b6a69459a270a7df301",
"assets/assets/appIcon.png": "eb5582583a41d456790ecb447a803e09",
"assets/assets/burger.png": "71dec637a7a2d390ebec2107878262c5",
"assets/assets/onboard_2.png": "fad6948082c63218aad2d48ab86102bf",
"assets/assets/biryani/biryani2.png": "80e78c1e1c254dfe1fb89bd6ac0f461b",
"assets/assets/biryani/biryani3.png": "a2af4c7c30ada6a7baab1bd398779a1e",
"assets/assets/biryani/biryani1.png": "a5444d8ccbbd7b39c70ab9126efe4191",
"assets/assets/salad.png": "edb6a9668c2ba6243e48fcfc98083eb4",
"assets/assets/berry-bonanza-waffle.png": "90e68ac447121f5bb7cada238aa287ff",
"assets/assets/onboard_3.png": "13eee42b59ae79351e9fbe337e35b681",
"assets/assets/ramen/fullset_ramen.png": "9569256721262d0f58bb66c3705b94b6",
"assets/assets/ramen/kurume_ramen.png": "314906f10f1861c5fd05dbdaf66c14a3",
"assets/assets/ramen/shrimp_fried_rice.png": "e7da4c5d7aaa02571f1f9c81a9fed062",
"assets/assets/ramen/sapporo_miso_ramen.png": "f7d958da14d9e7dd5d879ce898f8019e",
"assets/assets/ramen/hakata_ramen.png": "418956642b6b6d8b9ade335758d2aff1",
"assets/assets/ramen.png": "0e76d0629ff9f179b69f6e2af38feeda",
"assets/NOTICES": "34ce72e70c433cdd9c14c5e9e3787d29",
"assets/AssetManifest.bin": "38280e6590565e4fdae084b3d0a4767c",
"assets/fonts/MaterialIcons-Regular.otf": "040f413119fa1ca42e833925146879d8",
"assets/AssetManifest.bin.json": "7d7e4a490a5364e282a5c4a04d961be4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "88d89dd24c0d417b5d9db32c2071691f",
"/": "88d89dd24c0d417b5d9db32c2071691f",
"manifest.json": "b5988025c86b037a3ecc06a3425f8f28",
"flutter.js": "f393d3c16b631f36852323de8e583132"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
