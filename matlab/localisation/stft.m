function [X, phi] = stft(fn_cfg, x, tbins)
%STFT Calculate the short-time fourier transformation (STFT) using a certain parameter set.

%% Description
% Calculate the short-time fourier transformation (STFT) using a certain parameter set.

%% Arguments
% * *fn_cfg (str)*: _File name of configuration file (e.g. |config_ds78f.mat|)_
% * *x (mat)*: _Matrix of time-domain signals to be transformed._
% * *tbins*: _Number of time-steps |T| (Overrides |em.T| from configuration)_

%% Returns
% * *X (mat)*: _Matrix with signals in the STFT domain_
% * *phi (mat)*: _Matrix of pair-wise relative phase ratios (PRPs)_

%% Initialisation
load(fn_cfg)
if nargin>2, em.T=tbins; fprintf('WARNING: Overring em.T with %d', tbins); end
try fprintf('\n<stft.m> (t = %2.4f)\n', toc); end

m = 'Calculate STFT of received signal...'; counter = next_step(m, counter);
    %% Dry-run
    % Do single transformation to determine, |em.T|. Update |em.T| if necessary. Then
    % initialise variables accordingly.
    TEMP = specgram(x(:,1,1),fft_bins,fs,fft_window,fft_overlap_samples);  % to find out stft output dimensions
    if em.T~=size(TEMP, 2), em.T=size(TEMP, 2); end
    X = zeros(fft_bins_net, em.T, 2, n_receiver_pairs);
    phi = zeros(em.K,em.T,n_receiver_pairs);
    %% STFT Calculation
    for mic_pair = 1:n_receiver_pairs
        for mic = 1:2
            x_temp = x(:,mic,mic_pair) + 0.01*(rand(size(x(:,1,mic_pair)))-0.5);
            X(:,:,mic,mic_pair) = specgram(x_temp,fft_bins,fs,fft_window,fft_overlap_samples);
        end
        phi(:,:,mic_pair) = (X(fft_freq_range,:,2,mic_pair)./X(fft_freq_range,:,1,mic_pair)).*abs(X(fft_freq_range,:,1,mic_pair)./X(fft_freq_range,:,2,mic_pair));
    end
    fprintf('%s done! (Elapsed Time = %s)\n', FORMAT_PREFIX, num2str(toc)');
end
