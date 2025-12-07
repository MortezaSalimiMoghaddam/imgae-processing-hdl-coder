function edge_image = canny_edge_detector(input_image, low_thresh, high_thresh)
    % Convert to grayscale if needed
    if size(input_image, 3) == 3
        input_image = rgb2gray(input_image);
    end
    
    % Step 1: Gaussian Filter
    gaussian_filter = fspecial('gaussian', [5, 5], 1);
    smoothed_image = imfilter(input_image, gaussian_filter, 'same');
    
    % Step 2: Gradient Calculation using Sobel
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
    Gx = imfilter(smoothed_image, sobel_x, 'same');
    Gy = imfilter(smoothed_image, sobel_y, 'same');
    gradient_magnitude = abs(Gx) + abs(Gy);
    gradient_direction = atan2d(Gy, Gx);
    
    % Step 3: Non-Maximum Suppression (simplified for MATLAB)
    suppressed_image = non_maximum_suppression(gradient_magnitude, gradient_direction);
    
    % Step 4: Hysteresis Thresholding
    edge_image = hysteresis_threshold(suppressed_image, low_thresh, high_thresh);
end

function suppressed = non_maximum_suppression(grad_mag, grad_dir)
    % Approximate gradient directions to 0, 45, 90, or 135 degrees
    % Perform suppression based on neighboring pixel comparison
    % (Example logic to be added)
    suppressed = grad_mag; % Placeholder
end

function final_edges = hysteresis_threshold(img, low, high)
    % Apply low and high thresholds
    strong_edges = (img > high);
    weak_edges = (img > low) & (img <= high);
    % Connect weak edges to strong edges
    % (Example logic to be added)
    final_edges = strong_edges; % Placeholder
end
