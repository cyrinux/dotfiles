// ==UserScript==
// @name        YouTube CPU Tamer
// @name:ja     YouTube CPU Tamer
// @name:zh-CN  YouTube CPU Tamer
// @namespace   knoa.jp
// @description It just reduces CPU usage on YouTube.
// @description:ja YouTubeでのCPU使用率を削減します。
// @description:zh-CN 减少YouTube页面上的CPU利用率。
// @include     https://www.youtube.com/*
// @include     https://www.youtube.com/embed/*
// @include     https://www.youtube-nocookie.com/embed/*
// @version     1.1.2
// @run-at      document-start
// ==/UserScript==

/*
[update]
The background interval is now 15s. It could improve the buffering issue.

[possible]
intervalかrequestAnimationframeをうまく扱えばスパチャ要素を削除しなくてもよくなる？
  LIVEスクリプトでやるべきか、こちらでやるべきか。いずれにしても統一が可能かも。

[memo]
interval
  interval 自体のインスタンスを減らすためにすべて1つの関数にまとめて実行する。
  前面タブなら250msごとに頻度を落とす。
  背面タブなら15秒ごとに頻度を落とす。
timeout
  前面タブではユーザーインタラクションに関わる場合があるのでそのまま実行する。
  背面タブなら interval の次回処理に託してしまう。(前面タブになるまでは15秒間隔)
    背面タブの clearInterval は、仮にあったとしても煩雑化を避けるために無視する。
@grant none を宣言しているとなぜか interval が無視されたりする。謎。
*/
(function(){
  const SCRIPTID = 'YouTubeCpuTamer';
  console.log(SCRIPTID, location.href);
  const BUNDLEDINTERVAL    =     250;/* the bundled interval */
  const BACKGROUNDINTERVAL = 15*1000;/* take even longer interval on hidden tab */
  /*
    [interval]
  */
  /* integrate each of intervals */
  /* bundle intervals */
  const originalSetInterval = window.setInterval.bind(window);
  window.setInterval = function(f, interval, ...args){
    //console.log(SCRIPTID, 'original interval:', interval, location.href);
    bundle[index] = {
      f: f.bind(null, ...args),
      interval: interval,
      lastExecution: 0,
    };
    return index++;
  };
  window.clearInterval = function(id){
    //console.log(SCRIPTID, 'clearInterval:', id, location.href);
    delete bundle[id];
  };
  /*
    [timeout]
  */
  /* kill the background timeouts after initializing */
  const originalSetTimeout = window.setTimeout.bind(window);
  window.setTimeout = function(f, timeout, ...args){
    //console.log(SCRIPTID, 'timeout:', timeout, location.href);
    if(document.hidden){
      bundle[index] = {
        f: f.bind(null, ...args),
        timeout: timeout,
        lastExecution: 0,
      };
      return index++;
    }
    return originalSetTimeout(f, timeout, ...args);
  };
  /*
    [bundled process]
  */
  /* execute bundled intervals */
  /* a bunch of intervals does cost so much even if the processes do nothing */
  const bundle = {};/* {0: {f, interval, lastExecution}} */
  let index = 1;/* use it instead of interval id */
  let lastExecution = 0;
  originalSetInterval(function(){
    const now = Date.now();
    if(document.hidden && now < lastExecution + BACKGROUNDINTERVAL) return true;
    //console.log(SCRIPTID, 'bundle:', bundle, location.href);
    Object.keys(bundle).forEach(id => {
      const item = bundle[id];
      if(item === undefined) return true;/* it could be occur on tiny deletion chance */
      if(now < item.lastExecution + (item.interval || item.timeout)) return true;/* not yet */
      item.f();
      if(item.interval !== undefined) item.lastExecution = now;
      else delete bundle[id];
    });
    lastExecution = now;
  }, BUNDLEDINTERVAL);
})();