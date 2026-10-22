#include <bits/stdc++.h>

using namespace std;

// --- Local Debugging Tool ---
#ifndef ONLINE_JUDGE
#define debug(x) cerr << #x << " = " << (x) << '\n'
#else
#define debug(x)
#endif
using ll = long long;
constexpr int INF = 1e9 + 7;
constexpr ll LINF = 1e18 + 7;

int main() {
  ios_base::sync_with_stdio(false);
  cin.tie(nullptr);

  ll n;
  cin >> n;

  vector<ll> arr(n);
  for (size_t i = 0; i < n; i++) {
    cin >> arr[i];
  }

  return 0;
}
