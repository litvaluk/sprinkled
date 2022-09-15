import { Injectable, NestMiddleware, Logger } from '@nestjs/common';

import { Request, Response, NextFunction } from 'express';

@Injectable()
export class HttpRequestLoggerMiddleware implements NestMiddleware {
  private logger = new Logger('HTTPRequestLogger');

  use(request: Request, response: Response, next: NextFunction): void {
    const { ip, method, baseUrl: url } = request;
    const userAgent = request.get('user-agent') || '';

    response.on('close', () => {
      const { statusCode } = response;

      this.logger.log(`${statusCode} ${method} ${url} - ${userAgent} ${ip}`);
    });

    next();
  }
}
