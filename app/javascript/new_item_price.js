function calculateAndDisplayFees() {
  const priceInput = document.getElementById("item-price");

  // 入力フィールドがない場合は処理を終了
  if (!priceInput) return;

  const inputValue = priceInput.value;
  const addTaxPrice = Math.floor(inputValue * 0.1);
  const profit = inputValue - addTaxPrice;
  
  document.getElementById('add-tax-price').textContent = addTaxPrice;
  document.getElementById('profit').textContent = profit;
}

// ページ読み込み時とフレーム読み込み時に計算を実行
document.addEventListener('turbo:load', calculateAndDisplayFees);
document.addEventListener('turbo:frame-load', calculateAndDisplayFees);

// フォーム送信後のイベントリスナーを追加
document.addEventListener('turbo:submit-end', calculateAndDisplayFees);

// 入力フィールドの値が変わった時に計算を実行
document.addEventListener('input', event => {
  if (event.target.id === "item-price") {
    calculateAndDisplayFees();
  }
});