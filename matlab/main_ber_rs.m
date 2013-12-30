% Script for drawing the BER plot of the UMTS turbo code, as specified 
% in ETSI TS 125 212 (search for it on Google if you like). 
% BPSK modulation over an AWGN channel is assumed.
% Copyright (C) 2010  Robert G. Maunder

% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, either version 3 of the License, or (at your 
% option) any later version.

% This program is distributed in the hope that it will be useful, but 
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General 
% Public License for more details.

% The GNU General Public License can be seen at http://www.gnu.org/licenses/.

% This .m file can be easily converted into a Lyceum-friendly function.
% You can do this by removing the commenting from Section 1 and instead commenting out Section 2.

% Section 1
%===============================================================
function main_ber_rs( SNR_start, SNR_delta, SNR_stop,n,k,symbols , chan, interleave)
%===============================================================

% Section 2
%===============================================================
%    clear all
%    frame_length = 40; % Choose your frame length K
%    SNR_start = -7; % Choose the starting SNR
%    SNR_delta = 1; % Choose the SNR hop
%    SNR_stop = inf; % Choose the stopping SNR
%===============================================================
tic;
if ischar(SNR_start)
    SNR_start = str2num(SNR_start);
end
if ischar(SNR_stop)
    SNR_stop = str2num(SNR_stop);
end
if ischar(SNR_delta)
    SNR_delta = str2num(SNR_delta);
end
if ischar(n)
    n = str2num(n);
end
if ischar(k)
    k = str2num(k);
end
if ischar(symbols)
    symbols = str2num(symbols);
end

if ~(nargin > 6)
    chan = '';
end
if ~(nargin > 7)
    interleave = '';
end

    
    
    iteration_count = 1; % Choose the maximum number of decoding iterations to perform
    chances = 3; % Choose how many iterations should fail to improve the decoding before the iterations are stopped early
    random_interleaver = 0; % Choose whether to use a random interleaver or the UMTS interleaver. Longer simulations will be needed for the random interleaver.

    frame_length = symbols;%306; %symbols
    
   
    
    % Setup the SNR for the first iteration of the loop.
    SNR_count = 1;
    SNR = SNR_start;
    
    % Store the BER achieved after every iteration
    BERs = ones(1,iteration_count);
    results = zeros(1,iteration_count+4);
    
    getenv('OS');
    seed = int32(toc*1e9);
    seed = int32(seed);
    rng(seed);

    % Choose a file to save the results into.
    filename = ['results_rs_',num2str(n),'_',num2str(k),'_',chan,'_',interleave,'_',num2str(SNR_start),'_',num2str(seed),'.mat'];

    
    
    % Loop until the job is killed or until the SNR target is reached.
    keepgoing = 1;
    while(keepgoing)
        keepgoing = 0;
        SNR_count = 1;
        SNR = SNR_start;
        while SNR <= SNR_stop
            
            flag = 0;
            if size(results,1) < SNR_count
                flag = 1;
            else if results(SNR_count,end) < 10000
                    flag = 1;
                end
            end
                
            if flag    
                keepgoing = 1;
                
                hEnc = comm.RSEncoder(n,k);%('CodewordLength',21,'MessageLength',9);
                hDec = comm.RSDecoder(n,k);%('CodewordLength',21,'MessageLength',9);
               
               
                % Convert from SNR (in dB) to noise power spectral density.
                N0 = 1/(10^(SNR/10));

                % Counters to store the number of errors and bits simulated so far.
                error_counts=zeros(1,iteration_count);
                bit_count=0;

                % Keep going until enough errors have been observed. 
                % This runs the simulation only as long as is required to keep the BER vs SNR curve smooth.
                while bit_count < 10000% || error_counts(iteration_count) < 10

                   
                    % Generate some random symbols (3 bit/sym)
                    
                    a = randi([0 7], frame_length,1);
                    
                    m = log2(n+1);
                    
                    %encode
                    encd = step(hEnc, a);                    
                    encb = double(uint16(dec2bin(encd,m))-48);

                   
                    % BPSK modulate them
                    a_tx = 2*(encb-0.5);
                    org_size = size(a_tx);
                    
                    a_tx_r = reshape(a_tx,1,numel(a_tx));
                    
                     it1 = 1:length(a_tx_r);
                       
                    if strcmp(chan,'fade')  
                        if strcmp(interleave,'full')
                            it1 = randperm(length(a_tx_r));   
                        end
                        a_tx_r = a_tx_r(it1);

                         %add wobble
                        u = (1:length(a_tx_r))./50;  
                        a_tx_r = a_tx_r.*0.2.*(sin(1.2*u)+.7*sin(2.1*u)+0.5*sin(3*u)+2.5);

                    end


                    % Send the BPSK signal over an AWGN channel
                    a_rx_r(it1) = a_tx_r + sqrt(N0/2)*(randn(size(a_tx_r))+1i*randn(size(a_tx_r)));
                    a_rx = reshape(a_rx_r,org_size);
                    
                    % BPSK demodulator                    
                    a_c = (abs(a_rx+1).^2-abs(a_rx-1).^2)/N0;
                   
                    demod = (a_c > 0);
                    rx_sym = bin2dec(num2str(demod));
                    
                    data_out = step(hDec,rx_sym);
                    
                    % see how many bit errors we have.
                    errors = sum(sum( double(uint16(dec2bin(data_out,m))-48) ~= double(uint16(dec2bin(a,m))-48)));


                    bit_count = bit_count + length(a*3);
                    
                    if errors > 0
                        ser=1;
                    else
                        ser=0;
                    end

                    % Store the SNR and BERs in a matrix and display it.
                    if size(results,1) < SNR_count
                        results(SNR_count,1) = SNR;
                        results(SNR_count,2) = length(a)*m;
                        results(SNR_count,3) = errors;
                        results(SNR_count,4) = 1;
                        results(SNR_count,5) = ser;
                        
                    else
                        results(SNR_count,1) = SNR;
                        results(SNR_count,2) = results(SNR_count,2)+length(a)*m;
                        results(SNR_count,3) = results(SNR_count,3) + errors;
                        results(SNR_count,4) = results(SNR_count,4)+1;
                        results(SNR_count,5) = results(SNR_count,5)+ser;
                    end


                    % Save the results into a binary file. This avoids the loss of precision that is associated with ASCII files.
                    save(filename, 'results', '-MAT');

                end
                results
                % For every SNR considered so far, plot the BER obtained after each decoding iteration.
                %for iteration_index = 1:iteration_count           
                %    semilogy(results(:,1),results(:,iteration_index+2)./results(:,2));
                %end
            end

            % Setup the SNR for the next iteration of the loop.
            SNR = SNR + SNR_delta;
            SNR_count = SNR_count + 1;
        end 
    end

