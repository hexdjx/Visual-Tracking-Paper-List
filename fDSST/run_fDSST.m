
function results=run_fDSST(seq, res_path, bSaveImage)


%parameters according to the paper
params.padding = 2.0;                   % extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output
params.scale_sigma_factor = 1/16;       % standard deviation for the desired scale filter output
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.interp_factor = 0.025;			% tracking model learning rate (denoted "eta" in the paper)
params.num_compressed_dim = 18;         % the dimensionality of the compressed features
params.refinement_iterations = 1;       % number of iterations used to refine the resulting position in a frame
params.translation_model_max_area = inf;% maximum area of the translation model
params.interpolate_response = 1;        % interpolation method for the translation scores
params.resize_factor = 1;               % initial resize

params.number_of_scales = 17;           % number of scale levels
params.number_of_interp_scales = 33;    % number of scale levels after interpolation
params.scale_model_factor = 1.0;        % relative size of the scale sample
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;      % the maximum size of scale examples
params.s_num_compressed_dim = 'MAX';    % number of compressed scale feature dimensions

params.visualization = 0;

params.init_pos = seq.init_rect(1,[2,1]) + floor(seq.init_rect(1,[4,3])/2);
params.wsize = seq.init_rect(1,[4,3]);
params.s_frames = seq.s_frames;
params.video_path = [];

results = fDSST(params);
disp(['fps: ' num2str(results.fps)]);
end

