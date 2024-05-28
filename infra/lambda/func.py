return_format = {
        'status' : 200,
        'body': json.dumps({
            'message' : 'success',
            'count' : str(views)
        })
    }
    return return_format