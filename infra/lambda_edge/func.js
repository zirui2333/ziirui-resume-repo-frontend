'use strict';

exports.lambda_handler = async (event) => {
    const request = event.Records[0].cf.request;
    let uri = request.uri;

    // Check if the URI already has a file extension
    const hasExtension = uri.match(/\.[^\/]+$/);

    // If the URI does not have a file extension and does not end with a slash
    if (!hasExtension && !uri.endsWith('/')) {
        // Append '/index.html' to the URI
        uri += '/index.html';
    } else if (uri.endsWith('/')) {
        // If the URI ends with a '/', append 'index.html'
        uri += 'index.html';
    }

    request.uri = uri;
    return request;
};
