---
title: "留聲的房間：被時間遺忘的紅包場｜Scroll Story"
output:
  html_document:
    theme: null
    self_contained: true
---

本文件使用自製 HTML + CSS + JavaScript 建立一個 scroll-driven 的紅包場專題頁。
以下以原始 HTML 形式直接嵌入在 R Markdown 中。

```{=html}
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>

<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body {
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    background:#000;
    color:#fff;
    overflow-x:hidden;
  }
  a { color:inherit; text-decoration:none; }

  /* ========== 1. Landing（開頭） ========== */
  .landing {
    height:100vh;
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
    text-align:center;
    background:radial-gradient(circle at top,#222 0,#050509 50%,#000 100%);
    padding:0 1.5rem;
    position:relative;
  }
  .landing-tag {
    font-size:.8rem;
    letter-spacing:.3em;
    text-transform:uppercase;
    opacity:.7;
    margin-bottom:.75rem;
  }
  .landing h1 {
    font-size:clamp(2.4rem,5vw,3.3rem);
    letter-spacing:.12em;
    margin-bottom:1rem;
  }
  .landing p {
    max-width:640px;
    margin:0 auto;
    line-height:1.8;
    opacity:.9;
  }
  .landing-cta {
    margin-top:2.5rem;
  }
  .landing-btn {
    border-radius:999px;
    border:1px solid rgba(255,255,255,.4);
    background:transparent;
    padding:.8rem 2rem;
    font-size:.9rem;
    letter-spacing:.12em;
    text-transform:uppercase;
    cursor:pointer;
    transition:background .2s ease, transform .2s ease, border-color .2s;
  }
  .landing-btn:hover {
    background:rgba(255,255,255,.06);
    transform:translateY(-1px);
    border-color:rgba(255,255,255,.8);
  }
  .scroll-hint {
    position:absolute;
    bottom:18px;
    left:50%;
    transform:translateX(-50%);
    font-size:.75rem;
    letter-spacing:.3em;
    text-transform:uppercase;
    opacity:.6;
    display:flex;
    flex-direction:column;
    align-items:center;
  }
  .scroll-bar {
    width:1px;
    height:32px;
    margin-top:6px;
    background:linear-gradient(to bottom, transparent, rgba(255,255,255,.8));
    animation:scrollPulse 1.5s infinite ease-in-out;
  }
  @keyframes scrollPulse {
    0%,100% { transform:translateY(0); opacity:.3; }
    50% { transform:translateY(8px); opacity:1; }
  }

  /* ========== 2. Onboarding（引導與簡介） ========== */
  .onboarding {
    min-height:200vh;
    padding:4rem 1.5rem;
    background:#050505;
  }
  .onboarding .row {
    min-height:200vh;
  }
  .onboard-left {
    position:relative;
  }
  .video-grid-sticky {
    position:sticky;
    top:0;
    height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
  }
  .video-grid {
    width:95%;
    max-width:780px;
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:10px;
  }
  .thumb-card {
    position:relative;
    border-radius:10px;
    overflow:hidden;
    cursor:pointer;
    background:#000;
  }
  .thumb-card video {
    width:100%;
    height:calc(50vh - 30px);
    object-fit:cover;
    filter:grayscale(.15);
    opacity:.9;
    transition:transform .4s ease, filter .4s ease, opacity .3s ease;
  }
  .thumb-card:hover video {
    transform:scale(1.04);
    filter:none;
    opacity:1;
  }
  .thumb-overlay {
    position:absolute;
    inset:0;
    background:linear-gradient(to top,rgba(0,0,0,.8),rgba(0,0,0,.1));
    display:flex;
    flex-direction:column;
    justify-content:flex-end;
    padding:1rem;
    pointer-events:none;
  }
  .thumb-label {
    font-size:.75rem;
    text-transform:uppercase;
    letter-spacing:.2em;
    opacity:.8;
  }
  .thumb-title {
    font-size:1.05rem;
    font-weight:600;
    margin-top:.25rem;
  }
  .thumb-note {
    font-size:.75rem;
    opacity:.7;
    margin-top:.15rem;
  }

  .onboard-right {
    display:flex;
    align-items:flex-start;
    justify-content:flex-start;
    padding-left:2rem;
    color:#f5f5f5;
  }
  .onboard-text {
    max-width:620px;
    padding-top:8vh;
    font-size:1rem;
    line-height:1.9;
  }
  .pill {
    display:inline-flex;
    align-items:center;
    gap:.5rem;
    font-size:.78rem;
    text-transform:uppercase;
    letter-spacing:.18em;
    opacity:.8;
    margin-bottom:.75rem;
  }
  .pill-dot {
    width:7px;
    height:7px;
    border-radius:999px;
    background:#4ecdc4;
  }
  .onboard-text h2 {
    font-size:1.4rem;
    margin-bottom:1.1rem;
  }
  .onboard-text p {
    margin-bottom:1rem;
    opacity:.9;
  }
  .chapter-list {
    font-size:.9rem;
    margin-top:.75rem;
  }
  .chapter-list li {
    margin-bottom:.45rem;
    opacity:.88;
  }
  .chapter-list span {
    font-weight:600;
  }

  /* ========== 3. 主章節（4 個 Core Chapters） ========== */
  .progress-strip {
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:4px;
    background:rgba(255,255,255,.08);
    z-index:1000;
  }
  .progress-bar-inner {
    height:100%;
    width:0%;
    background:linear-gradient(90deg,#ff6b6b,#4ecdc4,#45b7d1);
    transition:width .1s ease;
  }

  .chapters-wrapper {
    background:#000;
  }
  .chapter-outer {
    position:relative;
  }
  .chapter-video {
    position:sticky;
    top:0;
    height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    overflow:hidden;
    background:#000;
  }
  .chapter-video video {
    width:100%;
    height:100%;
    object-fit:cover;
  }
  .chapter-text {
    position:relative;
    max-width:900px;
    width:min(92%,900px);
    margin:0 auto;
    margin-top:-100vh; /* 疊在影片上 */
    padding:12vh 1.75rem 12vh;
    background:rgba(0,0,0,.78);
    color:#fff;
    min-height:200vh;
    display:flex;
    flex-direction:column;
    justify-content:flex-start;
  }
  .chapter-label {
    font-size:.78rem;
    text-transform:uppercase;
    letter-spacing:.22em;
    opacity:.8;
    margin-bottom:.6rem;
  }
  .chapter-text h3 {
    font-size:clamp(1.8rem,3.2vw,2.4rem);
    margin-bottom:1.5rem;
  }
  .chapter-text p {
    font-size:1.02rem;
    line-height:1.9;
    margin-bottom:1.2rem;
    text-align:justify;
    text-justify:inter-ideograph;
  }
  .chapter-footnote {
    font-size:.8rem;
    opacity:.7;
    margin-top:.75rem;
  }

  /* 影片控制按鈕 */
  .video-controls {
    position:fixed;
    right:18px;
    bottom:18px;
    display:flex;
    flex-direction:column;
    gap:6px;
    z-index:1100;
  }
  .ctrl-btn {
    border-radius:999px;
    border:1px solid rgba(255,255,255,.3);
    background:rgba(0,0,0,.7);
    padding:6px 12px;
    font-size:.78rem;
    cursor:pointer;
    white-space:nowrap;
    transition:background .2s ease, border-color .2s ease, transform .15s ease;
  }
  .ctrl-btn:hover {
    background:rgba(0,0,0,.9);
    border-color:rgba(255,255,255,.8);
    transform:translateY(-1px);
  }

  /* Footer */
  footer {
    padding:2rem 1.5rem;
    font-size:.8rem;
    text-align:center;
    background:#050505;
    opacity:.8;
  }

  /* RWD */
  @media (max-width:992px) {
    .onboard-right { padding-left:0; margin-top:2rem; }
    .onboarding { padding:3rem 1.25rem; }
    .chapter-text { padding:10vh 1.25rem 10vh; }
    .thumb-card video { height:32vh; }
  }
  @media (max-width:576px) {
    .video-grid {
      grid-template-columns:1fr;
    }
    .thumb-card video {
      height:40vh;
    }
    .video-controls {
      right:10px;
      bottom:10px;
    }
  }
</style>

<!-- 進度條 -->
<div class="progress-strip">
  <div class="progress-bar-inner" id="scrollProgress"></div>
</div>

<!-- 影片控制 -->
<div class="video-controls">
  <button class="ctrl-btn" id="playAll">▶ 播放全部</button>
  <button class="ctrl-btn" id="pauseAll">⏸ 暫停全部</button>
  <button class="ctrl-btn" id="toggleMute">🔇 靜音</button>
</div>

<!-- 1. Landing（開頭） -->
<section class="landing" id="landing">
  <div class="landing-tag">Scroll-driven Video Documentary</div>
  <h1>留聲的房間</h1>
  <p>
    在城市的夜裡，有些聲音會流走，有些會留下。<br>
    紅包場的舞台就是一個「留聲的房間」：<br>
    有人上台的原因和下台的理由，往往比歌聲更動人。<br><br>
    這是一支用捲動來「進入一個場域」的故事。你將跟著四段影像——舞台、移動、現場、餘韻——慢慢看見：<br>
    被誤解的、被記住的、被時代擠壓的，以及仍然倔強發亮的部分。
  </p>
  <div class="landing-cta">
    <button class="landing-btn" id="goOnboarding">進入故事</button>
  </div>
  <div class="scroll-hint">
    <span>SCROLL</span>
    <span class="scroll-bar"></span>
  </div>
</section>

<!-- 2. Onboarding（引導與簡介） -->
<section class="onboarding">
  <div class="container-fluid">
    <div class="row">
      <!-- 左：多影片縮圖區（四支不同影片） -->
      <div class="col-lg-7 onboard-left">
        <div class="video-grid-sticky">
          <div class="video-grid">
            <!-- Chapter 1 Thumb -->
            <div class="thumb-card" data-target="#chapter1">
              <video muted preload="metadata">
                <source src="C0564.mp4" type="video/mp4" />
              </video>
              <div class="thumb-overlay">
                <div class="thumb-label">Chapter 1</div>
                <div class="thumb-title">舞台以前</div>
                <div class="thumb-note">點擊捲動到第一章：亮起燈之前的夜</div>
              </div>
            </div>
            <!-- Chapter 2 Thumb -->
            <div class="thumb-card" data-target="#chapter2">
              <video muted preload="metadata">
                <source src="C0581.mp4" type="video/mp4" />
              </video>
              <div class="thumb-overlay">
                <div class="thumb-label">Chapter 2</div>
                <div class="thumb-title">移動的人</div>
                <div class="thumb-note">夜晚的路，比舞台還長</div>
              </div>
            </div>
            <!-- Chapter 3 Thumb -->
            <div class="thumb-card" data-target="#chapter3">
              <video muted preload="metadata">
                <source src="C0583.mp4" type="video/mp4" />
              </video>
              <div class="thumb-overlay">
                <div class="thumb-label">Chapter 3</div>
                <div class="thumb-title">現場的張力</div>
                <div class="thumb-note">舞台與台下之間的距離</div>
              </div>
            </div>
            <!-- Chapter 4 Thumb -->
            <div class="thumb-card" data-target="#chapter4">
              <video muted preload="metadata">
                <source src="C0595.mp4" type="video/mp4" />
              </video>
              <div class="thumb-overlay">
                <div class="thumb-label">Chapter 4</div>
                <div class="thumb-title">留下的聲音</div>
                <div class="thumb-note">演出結束後，世界不會因此安靜</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右：專題說明文字 -->
      <div class="col-lg-5 onboard-right">
        <div class="onboard-text">
          <div class="pill">
            <span class="pill-dot"></span>
            <span>Onboarding · 導覽與專題簡介</span>
          </div>
          <h2>如何閱讀這個紅包場故事？</h2>
          <p>
            這是一個實驗性的 scroll-driven 敘事。它不追求快速傳遞資訊，而是希望你在畫面裡「停留」一下。
            每捲動一次，不只是拉動頁面高度，而是讓你往紅包場的現場更靠近一步。
          </p>
          <p>
            左邊的四個縮圖，是這個紅包場故事的四個切面：
          </p>
          <ul class="chapter-list">
            <li><span>CH1｜舞台以前：</span>舞台從不是表演的起點，而是所有故事的交會點。</li>
            <li><span>CH2｜移動的人：</span>歌手、樂手、陪唱師、跑場司機——每個夜晚都在路上。</li>
            <li><span>CH3｜現場的張力：</span>舞台與台下之間，有時候不是距離，而是誤解。</li>
            <li><span>CH4｜留下的聲音：</span>演出結束後，聲音消失得很快，但痕跡會留下來。</li>
          </ul>
          <p>
            如果你願意，可以直接點擊縮圖跳到該章節；也可以往下捲，順著影片的節奏慢慢往裡面走。
            這一次的觀看，不只是你點開影片，而是你「進到」影片裡。
          </p>
          <p style="font-size:.88rem;opacity:.75;margin-top:1rem;">
            操作提示：滑鼠移到左邊縮圖可以預覽動態畫面；點擊會捲動到對應章節。
            你也可以直接往下捲，順著影片與文字的節奏閱讀。
          </p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- 3. 主章節區（Core Narrative Chapters） -->
<main class="chapters-wrapper">
  <!-- Chapter 1 -->
  <section class="chapter-outer" id="chapter1">
    <div class="chapter-video">
      <video class="chapter-video-el" muted preload="metadata" loop>
        <source src="C0564.mp4" type="video/mp4" />
      </video>
    </div>
    <div class="chapter-text">
      <div class="chapter-label">Chapter 1 · 舞台以前</div>
      <h3>亮起燈之前的夜</h3>
      <p>
        在紅包場，舞台亮起的瞬間，其實不是故事的開始。
        真正的開始，是那些「還沒開始」的時刻：
      </p>
      <p>
        化妝鏡前的深呼吸、試麥時的輕哼、樂手把拾音器插上、主持人翻著手卡練習口條。
        這些聲音比唱歌還安靜，卻裝著更多重量。
      </p>
      <p>
        舞台前的十秒，是歌手一天中最長的十秒。
        不是因為緊張，而是因為那一刻，她要把白天的自己交給夜晚的自己代替。
      </p>
      <p>
        外面的人看紅包場，看的是「熱鬧」。
        只有站在台上的人，才知道熱鬧之前的空洞有多深。
      </p>
      <p>
        你捲動的速度決定你的靠近速度。
        而鏡頭始終停在同一個位置——就像舞台永遠在那裡等你，但它從不會主動走向你。
      </p>
      <p class="chapter-footnote">
        本章影片建議：使用 backstage、打燈準備、鏡頭慢慢 zoom-in 的段落，
        讓觀者在穩定的畫面中，感覺到情緒慢慢聚焦。
      </p>
    </div>
  </section>

  <!-- Chapter 2 -->
  <section class="chapter-outer" id="chapter2">
    <div class="chapter-video">
      <video class="chapter-video-el" muted preload="metadata" loop>
        <source src="C0581.mp4" type="video/mp4" />
      </video>
    </div>
    <div class="chapter-text">
      <div class="chapter-label">Chapter 2 · 移動的人</div>
      <h3>夜晚的路，比舞台還長</h3>
      <p>
        沒有一個紅包場歌手只唱一個場。跑場，就是他們的日常——路，比舞台長；夜，比台前亮。
      </p>
      <p>
        你會看到有人塞音響、有人換高跟鞋、有人在後座補妝、有人在機車後箱放著亮片服。
        城市的每條支線，都穿過他們的生活。
      </p>
      <p>
        鏡頭在這一章變得不穩，不是拍得不好，而是世界本來就在晃。
      </p>
      <p>
        有人問過一位歌手：「妳一天跑幾場啊？」她說：「看錢，看心情，看生活怎麼逼我。」
      </p>
      <p>
        捲動到這裡，你可能會開始感覺：這不是一份工作，是一種移動中的狀態——
        一種把命運背在身上的移動。
      </p>
      <p class="chapter-footnote">
        本章影片建議：車窗、路燈、移動中剪影、騎車或開車的路景、收音含風聲與車聲，
        讓觀者感覺自己暫時坐上了跑場的那班車。
      </p>
    </div>
  </section>

  <!-- Chapter 3 -->
  <section class="chapter-outer" id="chapter3">
    <div class="chapter-video">
      <video class="chapter-video-el" muted preload="metadata" loop>
        <source src="C0583.mp4" type="video/mp4" />
      </video>
    </div>
    <div class="chapter-text">
      <div class="chapter-label">Chapter 3 · 現場的張力</div>
      <h3>舞台與台下之間沒有那麼遠，也沒有那麼近</h3>
      <p>
        紅包場的現場是一種獨特的張力。台上和台下的距離，很近；理解和誤解的距離，很遠。
      </p>
      <p>
        有人真心聽歌，有人只是喝酒、有人想被叫名字、有人只在等待塞紅包的那一刻。
        而台上的歌手，必須用一雙眼睛同時看懂這麼多人。
      </p>
      <p>
        外界總把紅包場講得太簡單：「就是拿錢唱歌嘛。」
        但真正的現場不是「表演」，而是「交換」。
      </p>
      <p>
        有人拿聲音換生活，有人拿紅包換被看見一秒鐘的感覺。
      </p>
      <p>
        如果你捲得很慢，你會感覺到壓力在推你；如果你捲得很快，你會錯過他們彼此之間那一瞬間的真心。
      </p>
      <p class="chapter-footnote">
        本章影片建議：台上俯拍台下、台下仰拍台上、舞台邊緣、搖晃的燈光與鏡頭移動，
        讓讀者感覺自己就坐在其中一張桌子邊。
      </p>
    </div>
  </section>

  <!-- Chapter 4 -->
  <section class="chapter-outer" id="chapter4">
    <div class="chapter-video">
      <video class="chapter-video-el" muted preload="metadata" loop>
        <source src="C0595.mp4" type="video/mp4" />
      </video>
    </div>
    <div class="chapter-text">
      <div class="chapter-label">Chapter 4 · 留下的聲音</div>
      <h3>演出結束後，世界不會因此安靜</h3>
      <p>
        一場演出結束得很快，甚至快到讓人來不及把情緒收回來。
      </p>
      <p>
        散場後，只剩桌面上的紙巾、酒杯、地上掉的亮片、麥克風座上的餘震。
        聲音消失得很快，但痕跡會留很久。
      </p>
      <p>
        更多的痕跡不是留在場地，而是留在那些人身上：
      </p>
      <p>
        留在歌手卸妝時的眼角、留在樂手背著樂器回家的肩膀、
        留在陪唱師把夜裡收到的故事藏進沉默裡。
      </p>
      <p>
        鏡頭在這裡慢慢變安靜。世界沒有比上一章更明亮，也沒有更黑暗。
        只是你看懂的部分比較多了。
      </p>
      <p>
        你可以在這裡停下，也可以捲回去再看一次。
        故事沒有真正結束，因為真正的聲音不會只活在舞台上。
      </p>
      <p class="chapter-footnote">
        本章影片建議：收場、空場、散場、走路、夜色、街燈、慢動作，
        讓最後的影像像一個還沒完全關掉的燈，留在讀者心裡一陣子。
      </p>
    </div>
  </section>
</main>

<footer>
  《留聲的房間：被時間遺忘的紅包場》 · Scroll Story Prototype<br>
  結構：開頭（Landing）→ 引導與簡介（Onboarding）→ 四個主章節（Core Narrative Chapters）
</footer>

<script>
  // 平滑捲動到 Onboarding
  document.getElementById("goOnboarding").addEventListener("click", () => {
    document.querySelector(".onboarding").scrollIntoView({ behavior: "smooth" });
  });

  // 縮圖 hover 播放 & click 捲動
  document.querySelectorAll(".thumb-card").forEach(card => {
    const video = card.querySelector("video");
    const targetSelector = card.getAttribute("data-target");

    card.addEventListener("mouseenter", () => {
      video.currentTime = 0;
      video.play().catch(() => {});
    });
    card.addEventListener("mouseleave", () => {
      video.pause();
      video.currentTime = 0;
    });
    card.addEventListener("click", () => {
      const target = document.querySelector(targetSelector);
      if (target) target.scrollIntoView({ behavior: "smooth" });
    });
  });

  // 收集所有章節影片
  const chapterVideos = document.querySelectorAll(".chapter-video-el");
  let muted = true;

  // 全域控制
  document.getElementById("playAll").addEventListener("click", () => {
    chapterVideos.forEach(v => v.play().catch(() => {}));
  });
  document.getElementById("pauseAll").addEventListener("click", () => {
    chapterVideos.forEach(v => v.pause());
  });
  document.getElementById("toggleMute").addEventListener("click", (e) => {
    muted = !muted;
    chapterVideos.forEach(v => v.muted = muted);
    e.target.textContent = muted ? "🔇 靜音" : "🔊 取消靜音";
  });

  // 捲動進度條 + 依章節自動播放對應影片
  const progressBar = document.getElementById("scrollProgress");
  const chapterSections = document.querySelectorAll(".chapter-outer");

  function handleScroll() {
    const scrollTop = window.scrollY;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
    const percent = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
    progressBar.style.width = percent + "%";

    chapterSections.forEach((section, idx) => {
      const rect = section.getBoundingClientRect();
      const v = chapterVideos[idx];
      if (!v) return;

      // 章節在視窗中段時播放，離開就暫停
      if (rect.top < window.innerHeight * 0.6 && rect.bottom > window.innerHeight * 0.4) {
        v.play().catch(() => {});
      } else {
        v.pause();
      }
    });
  }

  window.addEventListener("scroll", handleScroll);
  window.addEventListener("resize", handleScroll);
  handleScroll();
</script>
