-- =====================================================================
-- cp_snippets.lua
-- Focused collection of LuaSnip snippets for C++ competitive programming.
-- Triggers kept short & mnemonic. Non-intrusive.
-- =====================================================================

local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function date()
  return os.date "%Y-%m-%d"
end

ls.add_snippets("cpp", {
  s("main", fmt([[{}
using namespace std;

{};

int main() {{
    ios::sync_with_stdio(false); cin.tie(nullptr);
    int T = 1;{} // cin >> T;
    while (T--) {{
        {}
    }}
    return 0;
}}
]], {
    c(1, {
      t "#include <bits/stdc++.h>",
      t {"#include <bits/stdc++.h>", "#pragma GCC optimize(\"O2\")"},
    }),
    t "// helper funcs here",
    c(2, { t "", t " // multiple tests" }),
    i(0, "// solve"),
  })),

  s("fastio", t {
    "ios::sync_with_stdio(false);",
    "cin.tie(nullptr);",
  }),

  s("defs", t {
    "using ll = long long;",
    "using pii = pair<int,int>;",
    "using pll = pair<long long,long long>;",
    "#define all(x) (x).begin(), (x).end()",
    "#define sz(x) (int)(x).size()",
  }),

  s("dbg", t {
    "#ifdef LOCAL",
    "#define dbg(x) cerr << __LINE__ << ":" << #x << " = " << (x) << '\n'",
    "#else",
    "#define dbg(x) (void)0",
    "#endif",
  }),

  s("modops", fmt([[const int MOD = {};
inline int add(int a,int b){{ a+=b; if(a>=MOD) a-=MOD; return a; }}
inline int sub(int a,int b){{ a-=b; if(a<0) a+=MOD; return a; }}
inline int mul(long long a,long long b){{ return int(a*b%MOD); }}
int modpow(int a,long long e){{ int r=1; while(e){{ if(e&1) r=mul(r,a); a=mul(a,a); e>>=1; }} return r; }}
int inv(int a){{ return modpow(a, MOD-2); }}
]], { c(1, { t "1000000007", t "998244353" }) })),

  s("dsu", fmt([[struct DSU {{
  vector<int> p, sz;
  DSU(int n=0) {{ init(n); }}
  void init(int n) {{ p.resize(n); sz.assign(n,1); iota(all(p),0); }}
  int find(int x) {{ return p[x]==x?x:p[x]=find(p[x]); }}
  bool unite(int a,int b) {{ a=find(a); b=find(b); if(a==b) return false; if(sz[a]<sz[b]) swap(a,b); p[b]=a; sz[a]+=sz[b]; return true; }}
}};]], {})),

  s("bit", fmt([[struct BIT {{
  int n; vector<long long> ft;
  BIT(int n): n(n), ft(n+1,0) {{}}
  void add(int i,long long v) {{ for(++i;i<=n;i+=i&-i) ft[i]+=v; }}
  long long sumPrefix(int i) {{ long long r=0; for(++i;i>0;i-=i&-i) r+=ft[i]; return r; }}
  long long rangeSum(int l,int r) {{ return sumPrefix(r) - (l?sumPrefix(l-1):0); }}
}};]], {})),

  s("sieve", fmt([[vector<int> primes; vector<int> lp;
void sieve(int N) {{
  lp.assign(N+1,0);
  for(int i=2;i<=N;++i) {{
    if(!lp[i]) {{ lp[i]=i; primes.push_back(i); }}
    for(int p:primes) {{ if(p>lp[i] || 1LL*i*p>N) break; lp[i*p]=p; }}
  }}
}}]], {})),

  s("bfs", fmt([[queue<int> q; q.push({});
vector<int> dist(n, -1); dist[{}]=0;
while(!q.empty()) {{
  int v=q.front(); q.pop();
  for(int to: g[v]) if(dist[to]==-1) {{ dist[to]=dist[v]+1; q.push(to); }}
}}]], { i(1, "start"), i(2, "start") })),

  s("dfs", fmt([[function<void(int,int)> dfs = [&](int v,int p) {{
  {} // body
  for(int to: g[v]) if(to!=p) dfs(to,v);
}}; dfs({}, -1);]], { i(1, "// process v"), i(2, "root") })),

  s("v2", fmt([[vector<vector<{}>> {}({},{ vector<{}>({}) });]], {
    c(1, { t "int", t "long long", t "char" }),
    i(2, "grid"),
    i(3, "n"),
    c(4, { t "int", t "long long", t "char" }),
    i(5, "m"),
  })),

  s("pref", fmt([[vector<long long> pref(n+1,0);
for(int i=0;i<n;++i) pref[i+1]=pref[i]+{};]], { i(1, "a[i]") })),

  s("hdr", fmt([[// Author: {}
// Date  : {}
// Contest: {}
]], { i(1, "you"), f(date), i(2, "name") })),
})

-- Keep original simple cp snippet
ls.add_snippets("cpp", {
  s("cp", t {
    "#include <bits/stdc++.h>",
    "using namespace std;",
    "",
    "#define fast_io ios::sync_with_stdio(false); cin.tie(nullptr);",
    "#define all(x) (x).begin(), (x).end()",
    "#define sz(x) (int)(x).size()",
    "using ll = long long;",
    "",
    "int main() {",
    "    fast_io;",
    "    int T = 1;",
    "    // cin >> T;",
    "    while (T--) {",
    "        ",
    "    }",
    "    return 0;",
    "}",
  }),
})

-- =====================================================================
-- Additional algorithm & data structure snippets
-- Triggers chosen to avoid common word collisions.
-- =====================================================================

ls.add_snippets("cpp", {
  -- Vector + size declaration
  s("arr", fmt([[vector<{}> {}({});]], { c(1, { t"int", t"long long", t"double" }), i(2, "a"), i(3, "n") })),

  -- Segment tree (point update, range query sum)
  s("seg", fmt([[struct Seg {{
  int n; vector<long long> st;
  Seg(int n=0) {{ init(n); }}
  void init(int N) {{ n=1; while(n<N) n<<=1; st.assign(2*n,0); }}
  void build(const vector<long long>& a) {{ init((int)a.size()); for(int i=0;i<(int)a.size();++i) st[n+i]=a[i]; for(int i=n-1;i>0;--i) st[i]=st[2*i]+st[2*i+1]; }}
  void update(int p,long long v) {{ for(st[p+=n]=v; p>1; p>>=1) st[p>>1]=st[p]+st[p^1]; }}
  long long query(int l,int r) {{ // inclusive l,r
    long long res=0; for(l+=n, r+=n; l<=r; l>>=1, r>>=1) {{ if(l&1) res+=st[l++]; if(!(r&1)) res+=st[r--]; }} return res; }}
}};]], {})),

  -- Lazy segment tree (range add, range sum)
  s("segl", fmt([[struct SegL {{
  int n; vector<long long> st,lz;
  void init(int N) {{ n=1; while(n<N) n<<=1; st.assign(2*n,0); lz.assign(2*n,0); }}
  void push(int p,int len) {{ if(lz[p]==0) return; st[p]+=lz[p]*len; if(p<n) {{ lz[2*p]+=lz[p]; lz[2*p+1]+=lz[p]; }} lz[p]=0; }}
  void range_add(int l,int r,long long v,int p,int L,int R) {{ push(p,R-L+1); if(r<L||R<l) return; if(l<=L&&R<=r) {{ lz[p]+=v; push(p,R-L+1); return; }} int M=(L+R)/2; range_add(l,r,v,2*p,L,M); range_add(l,r,v,2*p+1,M+1,R); st[p]=st[2*p]+st[2*p+1]; }}
  long long range_sum(int l,int r,int p,int L,int R) {{ push(p,R-L+1); if(r<L||R<l) return 0; if(l<=L&&R<=r) return st[p]; int M=(L+R)/2; return range_sum(l,r,2*p,L,M)+range_sum(l,r,2*p+1,M+1,R); }}
}};]], {})),

  -- KMP prefix function
  s("kmp", fmt([[vector<int> pi({});
for(int i=1;i<{};++i) {{
  int j=pi[i-1];
  while(j>0 && {}[i]!= {}[j]) j=pi[j-1];
  if({}[i]=={}[j]) ++j;
  pi[i]=j;
}}]], { i(1,"n"), rep(1), i(2,"s"), i(2), i(2), i(2) })),

  -- Z-function
  s("zfn", fmt([[vector<int> z({}); z[0]=0; int l=0,r=0;
for(int i=1;i<{};++i) {{
  if(i<=r) z[i]=min(r-i+1,z[i-l]);
  while(i+z[i]<{} && {}[z[i]]=={}[i+z[i]]) ++z[i];
  if(i+z[i]-1>r) l=i, r=i+z[i]-1;
}}]], { i(1,"n"), rep(1), rep(1), i(2,"s"), i(2) })),

  -- Binary search on answer
  s("binans", fmt([[long long lo={}, hi={}, ans=-1; while(lo<=hi) {{ long long mid=(lo+hi)/2; if({}) ans=mid, hi=mid-1; else lo=mid+1; }}]], { i(1,"0"), i(2,"1e12"), i(3,"check(mid)") })),

  -- Dijkstra
  s("dijk", fmt([[const long long INF = (1LL<<60);
vector<long long> dist(n, INF); dist[{}]=0;
priority_queue<pair<long long,int>, vector<pair<long long,int>>, greater<pair<long long,int>>> pq; pq.push({{0, {}}});
while(!pq.empty()) {{ auto [d,v]=pq.top(); pq.pop(); if(d!=dist[v]) continue; for(auto [to,w]: g[v]) if(dist[to]>d+w) {{ dist[to]=d+w; pq.push({{dist[to],to}}); }} }}]], { i(1,"s"), rep(1) })),

  -- Topological sort (Kahn)
  s("topo", fmt([[queue<int> q; for(int i=0;i<n;++i) if(indeg[i]==0) q.push(i); vector<int> ord; ord.reserve(n);
while(!q.empty()) {{ int v=q.front(); q.pop(); ord.push_back(v); for(int to: g[v]) if(--indeg[to]==0) q.push(to); }}
// ord holds topological order (if size==n)
]], {})),

  -- Sparse table for RMQ (min)
  s("stbl", fmt([[int K = 32-__builtin_clz(n); vector<vector<int>> st(K, vector<int>(n));
for(int i=0;i<n;++i) st[0][i]=a[i];
for(int k=1;k<K;++k) for(int i=0;i + (1<<k) <= n; ++i) st[k][i]=min(st[k-1][i], st[k-1][i+(1<<(k-1))]);
auto qry = [&](int l,int r) {{ int k=31-__builtin_clz(r-l+1); return min(st[k][l], st[k][r-(1<<k)+1]); }};]], {})),

  -- LIS n log n
  s("lis", t {
    "vector<int> d; vector<int> pos, par;",
    "int n = a.size(); pos.assign(n,-1); par.assign(n,-1);",
    "for(int i=0;i<n;++i){",
    "  int x=a[i]; auto it=lower_bound(d.begin(), d.end(), x); int idx=it-d.begin();",
    "  if(it==d.end()) d.push_back(x); else *it=x;",
    "  pos[idx]=i; if(idx) par[i]=pos[idx-1];",
    "}",
    "// length d.size(), reconstruct:",
    "vector<int> seq; int cur=pos[d.size()-1]; while(cur!=-1){ seq.push_back(a[cur]); cur=par[cur]; } reverse(seq.begin(), seq.end());",
  }),

  -- Coordinate compression
  s("ccmp", t {
    "vector<int> vals = a; sort(all(vals)); vals.erase(unique(all(vals)), vals.end());",
    "for(int &x: a) x = lower_bound(all(vals), x) - vals.begin();",
  }),

  -- Precompute factorial & inverse factorial (mod)
  s("comb", fmt([[vector<int> fact({}+1), ifact({}+1);
fact[0]=1; for(int i=1;i<= {}; ++i) fact[i]=1LL*fact[i-1]*i%MOD;
ifact[{}]=inv(fact[{}]); for(int i={} ; i>0; --i) ifact[i-1]=1LL*ifact[i]*i%MOD;
auto C = [&](int n,int k)->int{{ if(k<0||k>n) return 0; return 1LL*fact[n]*ifact[k]%MOD*ifact[n-k]%MOD; }};]], { i(1,"N"), rep(1), rep(1), rep(1), rep(1), rep(1) })),

  -- LCA (binary lifting skeleton)
  s("lca", t {
    "int LOG = 32-__builtin_clz(n);",
    "vector<vector<int>> up(LOG, vector<int>(n,-1)); vector<int> depth(n);",
    "function<void(int,int)> dfs = [&](int v,int p){ up[0][v]=p; for(int k=1;k<LOG;++k) up[k][v]= (up[k-1][v]<0?-1: up[k-1][ up[k-1][v] ]); for(int to: g[v]) if(to!=p){ depth[to]=depth[v]+1; dfs(to,v);} };",
    "dfs(0,-1);",
    "auto lift = [&](int v,int d){ for(int k=0;k<LOG;++k) if(d>>k & 1) v = (v<0?-1: up[k][v]); return v; };",
    "auto lca = [&](int a,int b){ if(depth[a]<depth[b]) swap(a,b); a=lift(a, depth[a]-depth[b]); if(a==b) return a; for(int k=LOG-1;k>=0;--k) if(up[k][a]!=up[k][b]) a=up[k][a], b=up[k][b]; return up[0][a]; };",
  }),

  -- Matrix fast exponent (square matrix n x n)
  s("matpow", t {
    "using Mat = vector<vector<long long>>;",
    "Mat mul(const Mat &A,const Mat &B){ int n=A.size(); Mat C(n, vector<long long>(n)); for(int i=0;i<n;++i) for(int k=0;k<n;++k) if(A[i][k]) for(int j=0;j<n;++j) C[i][j]=(C[i][j]+A[i][k]*B[k][j])%MOD; return C; }",
    "Mat mpow(Mat A,long long e){ int n=A.size(); Mat R(n, vector<long long>(n)); for(int i=0;i<n;++i) R[i][i]=1; while(e){ if(e&1) R=mul(R,A); A=mul(A,A); e>>=1; } return R; }",
  }),

  -- RNG helper
  s("rng", t {"mt19937_64 rng(chrono::steady_clock::now().time_since_epoch().count());","auto rnd = [&](long long l,long long r){ return uniform_int_distribution<long long>(l,r)(rng); };"}),

  -- Fast scanner (int)
  s("scan", t {"auto readInt=[&](){ int x=0,c=getchar_unlocked(),s=1; while(c<'0'||c>'9'){ if(c=='-') s=-1; c=getchar_unlocked(); } while(c>='0'&&c<='9'){ x=x*10+c-'0'; c=getchar_unlocked(); } return x*s; };"}),

  -- Bitset usage example
  s("bs", fmt([[bitset<{}> {};]], { i(1, "N"), i(2, "bs") })),
})

-- =====================================================================
-- End cp_snippets.lua
-- =====================================================================
