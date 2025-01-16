function fuzzy_production_estimator()
  % GUI untuk Fuzzy Production Estimator

  figure('Name', 'Fuzzy Production Estimator', 'Position', [300, 200, 600, 400]);

  % Label Input Permintaan
  uicontrol('Style', 'text', 'Position', [50, 300, 150, 30], 'String', 'Permintaan (8-24)', ...
            'HorizontalAlignment', 'left', 'FontSize', 10);

  % Input Permintaan
  permintaan_input = uicontrol('Style', 'edit', 'Position', [200, 300, 100, 30], ...
                               'FontSize', 10);

  % Label Input Persediaan
  uicontrol('Style', 'text', 'Position', [50, 250, 150, 30], 'String', 'Persediaan (30-60)', ...
            'HorizontalAlignment', 'left', 'FontSize', 10);

  % Input Persediaan
  persediaan_input = uicontrol('Style', 'edit', 'Position', [200, 250, 100, 30], ...
                               'FontSize', 10);

  % Tombol Hitung
  uicontrol('Style', 'pushbutton', 'Position', [150, 200, 100, 40], ...
            'String', 'Hitung Produksi', 'FontSize', 10, ...
            'Callback', @(~,~) calculate_production(permintaan_input, persediaan_input));

  % Label Output Produksi
  uicontrol('Style', 'text', 'Position', [50, 150, 150, 30], 'String', 'Jumlah Produksi', ...
            'HorizontalAlignment', 'left', 'FontSize', 10);

  % Output Produksi
  produksi_output = uicontrol('Style', 'text', 'Position', [200, 150, 100, 30], ...
                               'String', '0', 'FontSize', 10, ...
                               'BackgroundColor', 'white', 'HorizontalAlignment', 'center');

  % Fungsi untuk kalkulasi produksi
  function calculate_production(p_input, s_input)
    % Ambil input permintaan dan persediaan
    permintaan = str2double(get(p_input, 'String'));
    persediaan = str2double(get(s_input, 'String'));

    % Validasi input
    if isnan(permintaan) || isnan(persediaan) || ...
       permintaan < 8 || permintaan > 24 || ...
       persediaan < 30 || persediaan > 60
      errordlg('Input permintaan atau persediaan tidak valid. Pastikan sesuai rentang.', 'Error');
      return;
    endif

    % Hitung produksi dengan fuzzy inference
    produksi = fuzzy_inference(permintaan, persediaan);

    % Tampilkan hasil produksi
    set(produksi_output, 'String', num2str(produksi));
  endfunction
endfunction

function produksi = fuzzy_inference(permintaan, persediaan)
  % Fungsi untuk menghitung jumlah produksi menggunakan logika fuzzy

  % Fuzzy set Permintaan
  permintaan_sedikit = membership(permintaan, [8, 11, 14]);
  permintaan_sedang = membership(permintaan, [13, 16, 19]);
  permintaan_banyak = membership(permintaan, [18, 21, 24]);

  % Fuzzy set Persediaan
  persediaan_sedikit = membership(persediaan, [30, 38, 45]);
  persediaan_sedang = membership(persediaan, [38, 45, 50]);
  persediaan_banyak = membership(persediaan, [47, 55, 60]);

  % Rule base fuzzy
  produksi_sedikit = max([ ...
    min(permintaan_sedikit, persediaan_sedikit), ...
    min(permintaan_sedang, persediaan_sedikit), ...
    min(permintaan_sedang, persediaan_sedang)]);

  produksi_banyak = max([ ...
    min(permintaan_sedang, persediaan_banyak), ...
    min(permintaan_banyak, persediaan_sedikit), ...
    min(permintaan_banyak, persediaan_banyak)]);

  % Defuzzifikasi menggunakan metode centroid sederhana
  produksi = (produksi_sedikit * 12.5 + produksi_banyak * 22.5) / ...
             (produksi_sedikit + produksi_banyak);
endfunction

function mu = membership(x, range)
  % Fungsi keanggotaan segitiga
  a = range(1); b = range(2); c = range(3);
  if x <= a || x >= c
    mu = 0;
  elseif x > a && x <= b
    mu = (x - a) / (b - a);
  elseif x > b && x < c
    mu = (c - x) / (c - b);
  else
    mu = 0;
  endif
endfunction

